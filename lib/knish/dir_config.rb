module Knish
  class DirConfig < Struct.new(:path, :db_dir)
    def next
      (existing_ids.max || 0) + 1
    end

    def root
      "#{db_directory}/#{path}"
    end

    def data_file
      'data.json'
    end

    private

    def existing_ids
      Dir.glob("#{root}/*").map{|d| d.split('/').last.to_i }
    end

    def db_directory
      @db_directory ||= db_dir || default_db_directory
    end

    def default_db_directory
      "#{`pwd`}/db/knish"
    end
  end
end
