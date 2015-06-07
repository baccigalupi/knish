module Knish
  class Collection < SimpleDelegator
    attr_reader :name, :config

    def initialize(name, parent_config)
      super([])
      @name = name
      @config = CollectionConfig.new(parent_config, name)
    end

    def add(model)
      configure(model)
      push(model)
    end

    alias :<< :add

    def save
      each(&:save)
    end

    def load
      clear
      config.generic_model_configs.each do |c|
        push(
          Member.new(config, c).loaded_model
        )
      end
      self
    end

    #def new(klass, attributes)
      
    #end

    def next_id
      config.next_id + select{|m| !m.persisted? }.size
    end

    def configure(model)
      model.config = config.member_config(model.config)
    end
  end
end
