require 'spec_helper'

RSpec.describe Knish, '.build' do
  let(:config) { project_class.config }

  context 'when all model level configuration' do
    let(:project_class) {
      Knish.build('projects') do |config|
        config.data_attributes = ['name', 'url']
        config.markdown_attributes = ['description']
        config.collections = ['stories']
      end
    }

    it 'builds a model class with the right attributes' do
      expect(project_class.ancestors).to include(Knish::Model)
    end

    it 'has the right data in the model config' do
      expect(config).to be_a(Knish::ModelConfig)
      expect(config.path).to eq('projects')
    end

    it 'adds the right class configuration attributes to the model class' do
      expect(config.data_attributes).to eq(['name', 'url'])
      expect(config.markdown_attributes).to eq(['description'])
      expect(config.collections).to eq(['stories'])
    end
  end

  context 'when some model level configuration is set' do
    let(:project_class) {
      Knish.build('projects') { |c| c.collections = ['features'] }
    }

    it 'sets missing model configuration to an empty array' do
      expect(config.data_attributes).to eq([])
      expect(config.markdown_attributes).to eq([])
    end
  end

  context 'when setting db level configuration' do
    let(:project_class) {
      Knish.build('projects') do |config|
        config.db_name = 'pizza'
        config.data_attributes = ['name', 'url']
      end
    }

    it 'updates the database related configuration' do
      expect(config.db_name).to eq('pizza')
    end
  end

  context 'when Knish already has custom global database configuration' do
    let(:project_class) {
      Knish.build('projects') do |config|
        config.db_name = 'pizza'
        config.data_attributes = ['name', 'url']
      end
    }

    before do
      Knish.configure do |config|
        config.data_filename = 'json-data.json'
      end
    end

    it 'does not mutate the Knish global configuration' do
      expect(Knish.config.db_name).to_not eq('pizza')
    end

    it 'model db configuration includes changes made at Knish level' do
      expect(config.data_filename).to eq('json-data.json')
    end

    it 'includes configured modifications to the db setup' do
      expect(config.db_name).to eq('pizza')
    end

    it 'uses model level configurations' do
      expect(config.data_attributes).to eq(['name', 'url'])
    end
  end
end

