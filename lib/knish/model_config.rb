module Knish
  class ModelConfig < SimpleDelegator
    attr_accessor :db_config, :path, :id, :omitted_namespace
    attr_writer :data_attributes, :markdown_attributes, :collections

    def initialize(db_config, path, id=nil)
      super(db_config)
      @path = path
      @db_config = db_config
      @id = id || next_id
    end

    def data_attributes
      @data_attributes ||= []
    end

    def markdown_attributes
      @markdown_attributes ||= []
    end

    def collections
      @collections ||= []
    end

    def all_attributes
      data_attributes + markdown_attributes
    end

    def collection_root
      "#{db_config.db_root}/#{path}"
    end

    def model_root
      "#{collection_root}/#{id}"
    end

    def next_id
      ExistingModels.new(collection_root).next_id
    end

    def template_path
      "#{view_to_db_path}/#{db_name}/#{path}/#{id}"
    end

    def inspect
      DelegateInspector.new(self,
        [:db_config, :path, :id, :omitted_namespace, :data_attributes, :markdown_attributes, :collections]
      ).to_inspect
    end
  end
end
