module Knish
  class Writer
    attr_reader :config, :id

    def initialize(config, id)
      @config = config
      @id = id || @config.next
    end

    def build_directories(directories)
      make_root
      directories.each {|dir| FileUtils.mkdir_p("#{root}/#{dir}") }
    end

    def save_json(attributes)
      make_root
      write_file(config.data_file, attributes.to_json)
    end

    def save_markdown(attributes)
      make_root
      attributes.each do |key, data|
        write_file("_#{key}.md", data)
      end
    end

    def root
      "#{config.root}/#{id}"
    end

    private

    def write_file(filename, data)
      File.open("#{root}/#{filename}", 'w') { |f| f.write(data) }
    end

    def make_root
      FileUtils.mkdir_p(root) unless File.exist?(root)
    end
  end
end
