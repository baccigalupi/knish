module Knish
  class Reader
    attr_reader :config, :id

    def initialize(config, id)
      @config = config
      @config.id = id
    end

    def get_json
      JSON.parse(read_file(config.data_filename) || '{}')
    end

    def get_markdown(key)
      read_file("_#{key}.md") || ""
    end

    def template(key)
      "#{config.template_path}/#{key}"
    end

    private

    def read_file(filename)
      File.read("#{config.model_root}/#{filename}") rescue nil
    end
  end
end
