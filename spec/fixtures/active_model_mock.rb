module ActiveModel
  module Model
  end

  class Name < Struct.new(:klass, :namespace)
  end
end
