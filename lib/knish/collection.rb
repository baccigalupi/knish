module Knish
  class Collection < SimpleDelegator
    attr_reader :name, :parent_config

    def initialize(name, parent_config)
      super([])
      @name = name
      @parent_config = parent_config
    end

    def add(model)
      member = CollectionMember.new(model, self)
      member.validate_and_reconfigure
      push(member)
    end

    alias :<< :add

    def save
      each(&:save)
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
  end
end
