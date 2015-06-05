module Knish
  class Collection < SimpleDelegator
    attr_reader :name, :parent_config

    def initialize(name, parent_config)
      super([])
      @name = name
      @parent_config = parent_config
    end

    def add(model)
      push(configure(model))
    end

    alias :<< :add

    def save
      each(&:save)
    end

    def load
      clear
      models.each do |model|
        model.load
        add(model)
      end
      self
    end

    def next_id
      config.next_id + select{|m| !m.persisted? }.size
    end

    def config
      return @config if @config
      @config = parent_config.clone
      @config.path = "#{@config.path}/#{parent_config.id}/#{name}"
      @config
    end

    def configure(model)
      member = CollectionMember.new(model, self)
      member.validate_and_reconfigure
    end

    private

    def models
      model_readers.map do |reader|
        data = reader.get_json
        class_name = data[config.type_key]
        next unless class_name
        model_class = eval(class_name)
        model = model_class.new
        model
      end.compact
    end

    def model_readers
      config.model_paths.map do |path|
        model_config = config.clone
        model_config.id = path.split('/').last.to_i
        Reader.new(model_config)
      end
    end

  end
end
