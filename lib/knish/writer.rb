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
      File.open("#{root}/#{config.data_file}", 'w') { |f| f.write(attributes.to_json) }
    end

    def root
      "#{config.root}/#{id}"
    end

    private

    def make_root
      FileUtils.mkdir_p(root) unless File.exist?(root)
    end
  end
end
