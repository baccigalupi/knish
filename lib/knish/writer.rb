module Knish
  class Writer
    attr_reader :config, :id

    def initialize(config, id)
      @config = config
      @id = id || @config.next
    end
  end
end
