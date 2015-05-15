require 'spec_helper'

RSpec.describe Knish::DirConfig do
  let(:config) { Knish::DirConfig.new('projects', db_fixture_path) }

  describe '#root' do
    it 'returns the collection root path' do
      expect(config.root).to eq("#{db_fixture_path}/projects")
    end
  end

  describe '#next' do
    before { clear_db(db_fixture_path) }
    after  { clear_db(db_fixture_path) }

    context 'when there are no models in the collection' do
      it 'returns 1' do
        expect(config.next).to eq(1)
      end
    end

    context 'when there are already models in the system' do
      before { FileUtils.mkdir_p("#{config.root}/1") }

      it 'returns the next available id' do
        expect(config.next).to eq(2)
      end
    end

    context 'when a model is missing but was built' do
      before { FileUtils.mkdir_p("#{config.root}/2") }

      it 'returns the next available id' do
        expect(config.next).to eq(3)
      end
    end
  end
end
