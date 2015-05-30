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

  let(:data_path) { "#{model.config.model_root}/data.json" }

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

    it 'should have getters the collections' do
      expect(model).to respond_to('stories')
    end
  end

  context 'when initilaized with attributes' do
    let(:attrs) {
      {
        name: 'My New Project',
        url: 'github.com/baccigalupi/my-new-project',
        description: '#Headline!'
      }
    }

    it 'puts each of these into an attribute' do
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
      saved_data = JSON.parse(File.read(data_path))
      expect(saved_data['name']).to eq(attrs[:name])
      expect(saved_data['url']).to eq(attrs[:url])
    end

    it 'saves markdown files' do
      model.save
      expect(File.read("#{model.config.model_root}/_description.md")).to eq(attrs[:description])
    end
  end

  describe '#load' do
    let(:model_directory) { File.dirname(data_path) }

    before do
      FileUtils.mkdir_p(model_directory)
      File.open(data_path, 'w') { |f| f.write({name: 'Name'}.to_json) }
      File.open("#{model_directory}/_description.md", 'w') { |f| f.write("#Hello") }
    end

    it 'loads the data into attributes' do
      model.load
      expect(model.name).to eq('Name')
    end

    it 'loads the markdown files into attributes' do
      model.load
      expect(model.description).to eq('#Hello')
    end
  end

  describe '#template' do
    let(:reader) { double('reader') }

    it 'delegates it down to the reader' do
      allow(Knish::Reader).to receive(:new).and_return(reader)
      expect(reader).to receive(:template).with('key').and_return("some_path")
      expect(model.template('key')).to eq('some_path')
    end
  end

  describe 'adding to collections' do
    let(:feature_class) {
      Knish.build(path) do |config|
        config.db_directory = db_fixture_path
        config.data_attributes = ['name']
        config.markdown_attributes = ['overview', 'description', 'scenarios']
      end
    }

    let(:bug_class) {
      Knish.build(path) do |config|
        config.db_directory = db_fixture_path
        config.data_attributes = ['name']
        config.markdown_attributes = ['description', 'reproduction_steps', 'expected', 'actual', 'additional_information']
      end
    }

    it 'stores and retrieves any kind of Knish object to the collection' do
      model.stories.add(feature_class.new(name: 'Do something great, and quickly'))
      model.stories.add(bug_class.new(name: 'Fix all the badness, go!'))

      expect(model.stories.first).to be_a(feature_class)
      expect(model.stories.last).to be_a(bug_class)
    end

    it 'will raise an error when adding a non-Knish object' do
      expect {
        model.stories.add({name: 'what is going on?'})
      }.to raise_error
    end
  end
end
