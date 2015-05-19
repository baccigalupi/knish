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
    end

    def config
      @config ||= self.class.config.clone
    end

    class << self
      attr_accessor :config
    end

    private

    def data_attributes
      config.data_attributes.inject({}) do |hash, key|
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
