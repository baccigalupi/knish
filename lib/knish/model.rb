module Knish
  class Model
    if defined?(ActiveModel::Model)
      include ActiveModel::Model

      def self.model_name
        ActiveModel::Name.new(self, omitted_namespace)
      end
    end

    attr_writer :config

    def initialize(attrs=nil)
      attrs ||= {}
      set(attrs)
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
      set(reader.get_json)
      set(reader.get_markdown)
      set(reader.get_collections)
      true
    end

    def set(attrs)
      attrs.each do |key, value|
        next if key.to_sym == config.type_key.to_sym
        public_send("#{key}=", value)
      end
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

    def self.omitted_namespace
      config && config.omitted_namespace
    end

    private

    def collections
      config.collections.map {|collection| send(collection) }
    end

    def data_attributes
      extract_local_attributes(config.data_attributes).merge(___type: self.class.to_s)
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

    def writer
      @writer ||= Writer.new(config)
    end

    def reader
      @reader ||= Reader.new(config)
    end
  end
end
