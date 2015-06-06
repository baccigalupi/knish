module Knish
  class DelegateInspector < Struct.new(:object, :attributes)
    def to_inspect
      "#<#{object.class.name}:#{memory_location} #{mapped_attributes.join(' ')}>"
    end

    def memory_location
      '0x00%x' % (object.object_id << 1)
    end

    def mapped_attributes
      attributes.map do |attr|
        "@#{attr}=#{object.send(attr).inspect}"
      end
    end
  end
end
