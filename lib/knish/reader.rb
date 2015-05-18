module Knish
  class Reader
    attr_reader :config, :id

    def initialize(config, id)
      @config = config
      @id = id || @config.next
    end

    def get_json
      JSON.parse(read_file(config.data_filename) || '{}')
    end

    def get_markdown(key)
      read_file("#{root}/_#{key}.md") || ""
    end

    def template(key)
      
    end

    def root
      "#{config.root}/#{id}"
    end

    private

    def read_file(filename)
      File.read("#{root}/#{filename}") rescue nil
    end
  end
end
