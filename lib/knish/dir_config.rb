module Knish
  class DirConfig < Struct.new(:path, :db_dir)
    def next
      current_size + 1
    end

    def root
      "#{db_directory}/#{path}"
    end

    private

    def current_size
      Dir.glob("#{root}/*").size
    end

    def db_directory
      @db_directory ||= db_dir || default_db_directory
    end

    def default_db_directory
      "#{`pwd`}/db/knish"
    end
  end
end
