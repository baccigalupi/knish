module Knish
  class Reader
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def get_json
      JSON.parse(read_file(config.data_filename) || '{}')
    end

    def get_markdown
      config.markdown_attributes.inject({}) do |hash, key|
        hash[key] = read_markdown(key)
        hash
      end
    end

    def get_collections
      config.collections.inject({}) do |hash, collection_name|
        collection = Collection.new(collection_name, config)
        collection.load
        hash[collection_name] = collection
        hash
      end
    end

    def template(key)
      "#{config.template_path}/#{key}"
    end

    def persisted?
      !!read_file(config.data_filename)
    end

    def read_file(filename)
      File.read("#{config.model_root}/#{filename}") rescue nil
    end

    private

    def read_markdown(key)
      read_file("_#{key}.md") || ""
    end
  end
end
