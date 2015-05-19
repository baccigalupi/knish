module Knish
  class Model
    def initialize(attrs=nil)
      attrs ||= {}
      extract_attrs(attrs)
    end

    extend Forwardable

    def_delegators :config, :id, :id=

    def save
      writer.save_json(data_attributes)
      writer.save_markdown(markdown_attributes)
    end

    def load
      extract_attrs(reader.get_json)
      extract_attrs(reader.get_markdown)
    end

    def config
      @config ||= self.class.config.clone
    end

    class << self
      attr_accessor :config
    end

    private

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

    def extract_attrs(attrs)
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
