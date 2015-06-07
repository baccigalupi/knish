module Knish
  class ExistingModels < Struct.new(:path)
    def next_id
      (ids.max || 0) + 1
    end

    def ids
      paths.map{|path| id(path) }.compact
    end

    def paths
      Dir.glob("#{path}/*")
    end

    def data
      paths.map { |path|
        Data.new(id(path), path) if id(path)
      }.compact
    end

    def id(path)
      last = path.split('/').last
      last && last.to_i
    end

    Data = Struct.new(:id, :path)
  end
end
