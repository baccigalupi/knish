module Knish
  class Builder
    attr_reader :collection_name, :block

    def initialize(collection_name, &block)
      @collection_name = collection_name
      @block = block
    end

    def make_model
      klass = Class.new(Model)
      klass.config = config
      klass.send(:attr_accessor, *config.all_attributes)
      klass
    end

    def config
      model_config = ModelConfig.new(Knish.config.clone, collection_name)
      block.call(model_config)
      model_config
    end
  end
end
