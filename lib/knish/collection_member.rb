module Knish
  class CollectionMember < SimpleDelegator
    attr_reader :model, :collection

    def initialize(model, collection)
      @model = model
      @collection = collection
      super(model)
    end

    def validate_and_reconfigure
      raise_if_unacceptable
      update_config
      self
    end

    private

    def raise_if_unacceptable
      if !model.class.ancestors.include?(Knish::Model)
        raise ArgumentError, "must be a Knish object"
      end
    end

    def update_config
      config.id = next_id if !model.persisted?
      config.path = collection.config.path
    end

    def next_id
      collection.next_id
    end
  end
end
