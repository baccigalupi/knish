module Knish
  class ModelConfig < SimpleDelegator
    attr_accessor :db_config, :path, :id
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
      (existing_ids.max || 0) + 1
    end

    def template_path
      "#{view_to_db_path}/#{db_name}/#{path}/#{id}"
    end

    def model_paths
      Dir.glob("#{collection_root}/*")
    end

    private

    def existing_ids
      model_paths.map{|dir| dir.split('/').last.to_i }
    end
  end
end
