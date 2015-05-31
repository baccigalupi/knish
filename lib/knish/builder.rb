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
      add_collections(klass, config.collections)
      klass
    end

    def add_collections(klass, collections)
      collections.each do |collection|
        klass.class_eval <<-RUBY, __FILE__, __LINE__
          def #{collection}
            @#{collection} ||= Collection.new('#{collection}', config)
          end
        RUBY
      end
    end

    def config
      model_config = ModelConfig.new(Knish.config.clone, collection_name)
      block.call(model_config)
      model_config
    end
  end
end
