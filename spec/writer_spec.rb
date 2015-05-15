require 'spec_helper'

RSpec.describe Knish::Writer do
  let(:writer) { Knish::Writer.new(config, id) }
  let(:config) { Knish::DirConfig.new('posts', db_fixture_path) }

  context 'when id is nil' do
    let(:id) { nil }

    it 'should set the id to the next available number' do
      expect(writer.id).to eq(1)
    end
  end
end
