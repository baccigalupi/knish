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

    def template(key)
      "#{config.template_path}/#{key}"
    end

    private

    def read_file(filename)
      File.read("#{config.model_root}/#{filename}") rescue nil
    end

    def read_markdown(key)
      read_file("_#{key}.md") || ""
    end
  end
end
