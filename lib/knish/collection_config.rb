module Knish
  class CollectionConfig < SimpleDelegator
    attr_accessor :db_config, :path, :model_config, :unpersisted_count

    def initialize(model_config, path)
      super(model_config.db_config)
      @path = path
      @db_config = model_config.db_config
      @model_config = model_config
      @unpersisted_count = 0
    end

    def collection_root
      "#{model_config.model_root}/#{path}"
    end

    def next_id
      ExistingModels.new(collection_root).next_id + unpersisted_count
    end

    def generic_model_configs
      ExistingModels.new(collection_root).ids.map { |id| member_config(generic_config, id) }
    end

    def generic_config
      ModelConfig.new(Knish.config, '')
    end

    def inspect
      DelegateInspector.new(self,
        [:db_config, :model_config, :path]
      ).to_inspect
    end

    def member_config(original_config, id=nil)
      config = original_config.clone
      config.id = member_id(id)
      config.path = "#{model_config.path}/#{model_config.id}/#{path}"
      config
    end

    private

    def member_id(id)
      return id if id
      id = next_id
      self.unpersisted_count += 1
      id
    end

  end
end

