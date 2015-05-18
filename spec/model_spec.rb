require 'spec_helper'

RSpec.describe Knish::Model do
  let(:model_class) {
    c = Class.new(Knish::Model)
    c.config = config
    c
  }
end
