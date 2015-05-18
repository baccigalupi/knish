module Knish
  class Model
    def initialize(attrs=nil)
      id = attrs[:id] || attrs['id']
      self.id = id if id
    end

    extend Forwardable

    def_delegators :config, :id, :id=

    def config
      self.class.config
    end

    class << self
      attr_accessor :config
    end
  end
end
