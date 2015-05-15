require_relative 'spec_helper'

describe Knish::CollectionConfig do
  let(:config) { Knish::CollectionConfig.new('projects', db_fixture_path) }
  let(:db_fixture_path) { File.dirname(__FILE__) + "/fixtures/db/knish" }

  describe '#root' do
    it 'returns the collection root path' do
      expect(config.root).to eq("#{db_fixture_path}/projects")
    end
  end

  describe '#next' do
    before do
      FileUtils.rm_rf("#{config.root}/1")
    end

    after do
      FileUtils.rm_rf("#{config.root}/1")
    end

    describe 'when there are no models in the collection' do
      it 'returns 1' do
        expect(config.next).to eq(1)
      end
    end

    describe 'when there are already models in the system' do
      before do
        FileUtils.mkdir_p("#{config.root}/1")
      end

      it 'returns the next available id' do
        expect(config.next).to eq(2)
      end
    end
  end
end
