module Knish
  class DbConfig
    attr_writer :db_directory, :view_to_db_path, :data_filename, :db_name

    def db_directory
      @db_directory ||= `pwd`.chomp
    end

    def db_root
      "#{db_directory}/#{db_name}"
    end

    def db_name
      @db_name ||= 'knish'
    end

    def view_to_db_path
      @view_to_db_path ||= '/../..'
    end

    def data_filename
      @data_filename ||= 'data.json'
    end
  end
end
