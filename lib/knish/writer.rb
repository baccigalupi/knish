module Knish
  class Writer
    attr_reader :config, :id

    def initialize(config, id)
      @config = config
      @config.id = id if id
    end

    def build_directories(directories)
      make_root
      directories.each {|dir| FileUtils.mkdir_p("#{config.model_root}/#{dir}") }
    end

    def save_json(attributes)
      make_root
      write_file(config.data_filename, attributes.to_json)
    end

    def save_markdown(attributes)
      make_root
      attributes.each do |key, data|
        write_file("_#{key}.md", data)
      end
    end

    private

    def write_file(filename, data)
      File.open("#{config.model_root}/#{filename}", 'w') { |f| f.write(data) }
    end

    def make_root
      FileUtils.mkdir_p(config.model_root) unless File.exist?(config.model_root)
    end
  end
end
