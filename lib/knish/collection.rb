module Knish
  class Collection < SimpleDelegator
    def add(model)
      raise_if_unacceptable(model)
      self.<< model
    end

    def raise_if_unacceptable(model)
      if !model.class.ancestors.include?(Knish::Model)
        raise ArgumentError, "must be a Knish object"
      end
    end
  end
end
