module Knish
  class Model
    if defined?(ActiveModel::Model)
      include ActiveModel::Model
    end

    def initialize(attrs=nil)
      attrs ||= {}
      add_attrs(attrs)
    end

    extend Forwardable

    def_delegators :config, :id, :id=
    def_delegators :reader, :persisted?

    def save
      writer.save_json(data_attributes)
      writer.save_markdown(markdown_attributes)
      collections.each(&:save)
      true
    end

    def load
      add_attrs(reader.get_json)
      add_attrs(reader.get_markdown)
      true
    end

    def template(key)
      reader.template(key)
    end

    def config
      @config ||= self.class.config.clone
    end

    class << self
      attr_accessor :config
    end

    private

    def collections
      config.collections.map {|collection| send(collection) }
    end

    def data_attributes
      extract_local_attributes(config.data_attributes)
    end

    def markdown_attributes
      extract_local_attributes(config.markdown_attributes)
    end

    def extract_local_attributes(keys)
      keys.inject({}) do |hash, key|
        hash[key] = public_send(key)
        hash
      end
    end

    def add_attrs(attrs)
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def writer
      @writer ||= Writer.new(config)
    end

    def reader
      @reader ||= Reader.new(config)
    end
  end
end
