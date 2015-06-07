require 'spec_helper'

RSpec.describe Knish::Collection do
  let(:collection) { Knish::Collection.new('stories', parent_config) }
  let(:parent_config) { Knish::ModelConfig.new(fixture_db_config, 'projects') }

  let(:model_class) {
    Knish.build('features') do |config|
      config.db_directory = db_fixture_path
      config.data_attributes = ['name']
      config.markdown_attributes = ['description']
    end
  }

  describe '#add' do
    let(:model) { model_class.new }

    it 'puts the model in the collection' do
      collection.add(model)
      expect(collection.first).to eq(model)
    end

    it 'raises an error if the model is not a Knish object' do
      expect{
        collection.add({})
      }.to raise_error
    end

    it 'changes the configuration on the way in' do
      collection.add(model)
      expect(model.config.path).to eq('projects/1/stories')
    end

    context 'when objects of that class already exist in the model configured location' do
      let(:original_model_collection_path) { db_fixture_path + "/knish/features" }

      before do
        FileUtils.mkdir_p(original_model_collection_path + "/3")
      end

      after do
        clear_db(db_fixture_path)
      end

      it 'reevaluates the id in the configuration' do
        expect {
          collection.add(model)
        }.to change { model.config.id }

        expect(collection.first.id).to eq(1)
      end
    end
  end

  describe '#save' do
    let(:models) {
      [model_class.new(name: 'bar'), model_class.new(name: 'foo')]
    }

    it 'calls save on each of the models' do
      models.each do |m|
        expect(m).to receive(:save)
        collection.add(m)
      end
      collection.save
    end
  end

  describe '#load' do
    before do
      FileUtils.mkdir_p(collection.config.collection_root + "/1")
      File.open(collection.config.collection_root + "/1/data.json", 'w') {|f| f.write({name: 'Hello', ___type: 'Feature'}.to_json) }
      FileUtils.mkdir_p(collection.config.collection_root + "/2")
      File.open(collection.config.collection_root + "/2/data.json", 'w') {|f| f.write({name: 'Goodbye', ___type: 'Bug'}.to_json) }
    end

    after  { clear_db(db_fixture_path) }

    it 'should be the right size' do
      collection.load
      expect(collection.size).to eq(2)
    end

    it 'should remove existing models' do
      project = Project.new(name: 'not for saving, thanks!')
      collection << project
      collection.load
      expect(collection).not_to include(project)
    end

    it 'should build the right type of models for each' do
      collection.load

      expect(collection.first).to be_a(Feature)
      expect(collection.last).to be_a(Bug)
    end
  end
end
