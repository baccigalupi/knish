module Knish
  class Member < Struct.new(:collection_config, :config)
    def model
      return @model if @model
      @model = model_class.new(id: config.id)
      @model.config = collection_config.member_config(@model.config, config.id)
      @model
    end

    def loaded_model
      model.load
      model
    end

    def class_name
      data[config.type_key]
    end

    def model_class
      class_name && eval(class_name)
    end

    def data
      @data ||= reader.get_json
    end

    def reader
      Reader.new(config)
    end
  end
end
