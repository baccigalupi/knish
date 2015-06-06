module Knish
  class NextId < Struct.new(:path)
    def get
      (existing_ids.max || 0) + 1
    end

    def existing_ids
      Dir.glob("#{path}/*").map{|dir| dir.split('/').last }.compact.map(&:to_i)
    end
  end
end
