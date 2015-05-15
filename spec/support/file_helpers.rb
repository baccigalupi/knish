def clear_db(path)
  Dir.glob(path).each { |p| FileUtils.rm_rf(p) }
end

def db_fixture_path
  File.dirname(__FILE__) + "/../fixtures/db/knish"
end
