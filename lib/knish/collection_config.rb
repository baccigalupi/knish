module Knish
  class CollectionConfig < SimpleDelegator
    attr_accessor :db_config, :path, :model_config, :unpersisted_count

    def initialize(db_config, model_config, path)
      super(db_config)
      @path = path
      @db_config = db_config
      @model_config = model_config
      @unpersisted_count = 0
    end

    def collection_root
      "#{model_config.model_root}/#{path}"
    end

    def next_id
      NextId.new(collection_root).get + unpersisted_count
    end

    def inspect
      DelegateInspector.new(self,
        [:db_config, :model_config, :path]
      ).to_inspect
    end

    def member_config(klass, id)
      config = klass.config.clone
      config.id = id
      config.path = "#{model_config.path}/#{model_config.id}/#{path}"
      config
    end
  end
end

