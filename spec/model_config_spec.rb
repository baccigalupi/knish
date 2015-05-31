require 'spec_helper'

RSpec.describe Knish::ModelConfig do
  let(:config) { Knish::ModelConfig.new(fixture_db_config, 'projects') }

  describe '#id' do
    context 'when no id is passed in' do
      it 'uses the next id' do
        expect(config.id).to eq(config.next_id)
      end
    end

    context 'when an id is given' do
      let(:config) { Knish::ModelConfig.new(fixture_db_config, 'projects', 44) }

      it 'uses it' do
        expect(config.id).to eq(44)
      end
    end
  end

  describe '#collection_root' do
    it 'returns the collection root path' do
      expect(config.collection_root).to eq(File.expand_path("#{db_fixture_path}/knish/projects"))
    end
  end

  describe '#next_id' do
    before { clear_db(db_fixture_path) }
    after  { clear_db(db_fixture_path) }

    context 'when there are no models in the collection' do
      it 'returns 1' do
        expect(config.next_id).to eq(1)
      end
    end

    context 'when there are already models in the system' do
      before { FileUtils.mkdir_p("#{config.collection_root}/1") }

      it 'returns the next available id' do
        expect(config.next_id).to eq(2)
      end
    end

    context 'when a model is missing but was built' do
      before { FileUtils.mkdir_p("#{config.collection_root}/2") }

      it 'returns the next available id' do
        expect(config.next_id).to eq(3)
      end
    end
  end
end
