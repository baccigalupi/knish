def clear_db(path)
  Dir.glob(path).each { |p| FileUtils.rm_rf(p) }
end
