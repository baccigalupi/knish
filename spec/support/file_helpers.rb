def clear_db(path)
  Dir.glob(path).each { |p| FileUtils.rm_rf(p) }
end

def db_fixture_path
  File.expand_path(File.dirname(__FILE__) + "/../fixtures/db/knish")
end

def fixture_db_config
  c = Knish::DbConfig.new
  c.db_directory = File.expand_path(File.dirname(__FILE__) + "/../fixtures/db")
  c
end


