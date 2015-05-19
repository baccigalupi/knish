require 'spec_helper'

RSpec.describe Knish::Model do
  let(:model) { model_class.new(attrs) }

  let(:model_class) do
    Knish.build(path) do |config|
      config.db_directory = db_fixture_path
      config.data_attributes = ['name', 'url']
      config.markdown_attributes = ['description']
      config.collections = ['stories']
    end
  end

  let(:config) do
    Knish::ModelConfig.new(fixture_db_config, path, id)
  end

  let(:path) { 'projects' }

  let(:attrs) { {} }
  let(:id) { nil }

  before do
    clear_db(db_fixture_path)
    Knish.clear_config
  end

  after  { clear_db(db_fixture_path) }

  context 'when no id is provided' do
    let(:id) { nil }

    it 'uses the next id' do
      expect(model.id).to eq(1)
    end
  end

  context 'when an id is included in the initialization hash' do
    let(:attrs) { {id: 42} }

    it 'uses it' do
      expect(model.id).to eq(42)
    end
  end

  describe 'configed attributes' do
    it 'should have getters and setters for the data attributes' do
      expect(model).to respond_to('name')
      expect(model).to respond_to('name=')
      expect(model).to respond_to('url')
      expect(model).to respond_to('url=')
    end

    it 'should have getters and setters for the markdown attributes' do
      expect(model).to respond_to('description')
      expect(model).to respond_to('description=')
    end

    it 'should have getters and setters for the collections' do
      expect(model).to respond_to('stories')
      expect(model).to respond_to('stories=')
    end
  end

  context 'when configured with other attributes' do
    let(:attrs) {
      {
        name: 'My New Project',
        url: 'github.com/baccigalupi/my-new-project',
        description: '#Headline!'
      }
    }

    it 'loads each of these into an attribute' do
      expect(model.name).to eq(attrs[:name])
      expect(model.url).to eq(attrs[:url])
      expect(model.description).to eq(attrs[:description])
    end
  end

  describe '#save' do
    let(:attrs) {
      {
        name: 'My New Project',
        url: 'github.com/baccigalupi/my-new-project',
        description: '#Headline!'
      }
    }

    it 'saves to file the data attributes' do
      model.save
      saved_data = JSON.parse(File.read("#{model.config.model_root}/data.json"))
      expect(saved_data['name']).to eq(attrs[:name])
      expect(saved_data['url']).to eq(attrs[:url])
    end

    it 'saves markdown files' do
      model.save
      expect(File.read("#{model.config.model_root}/_description.md")).to eq(attrs[:description])
    end
  end

  describe '#load' do

  end

  describe '#template' do

  end
end
