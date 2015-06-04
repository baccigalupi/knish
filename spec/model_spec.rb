require 'spec_helper'

RSpec.describe Knish::Model do
  let(:model) { model_class.new(attrs) }

  let(:model_class) do
    Project # defined in support
  end

  let(:attrs) { {} }
  let(:id) { nil }

  let(:data_path) { "#{model.config.model_root}/data.json" }

  before { clear_db(db_fixture_path) }
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

    it 'sets each of these into an attribute' do
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

    let(:saved_data) { JSON.parse(File.read(data_path)) }

    let(:model) { Nested::Deeply::Is::Project.new(attrs) }

    it 'saves to file the data attributes' do
      model.save
      expect(saved_data['name']).to eq(attrs[:name])
      expect(saved_data['url']).to  eq(attrs[:url])
    end

    it 'also save the class name in a specal attribute' do
      model.save
      expect(saved_data['___type']).to eq('Nested::Deeply::Is::Project')
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
    it 'stores and retrieves any kind of Knish object to the collection' do
      model.stories << Feature.new(name: 'Do something great, and quickly')
      model.stories << Bug.new(name: 'Fix all the badness, go!')

      expect(model.stories.first.name).to eq('Do something great, and quickly')
      expect(model.stories.last.name).to eq('Fix all the badness, go!')
    end

    it 'saves the models to the right location' do
      model.stories << Feature.new(name: 'Do something great, and quickly')
      model.stories << Bug.new(name: 'Fix all the badness, go!')

      model.save

      expect(File.exist?("#{model.config.model_root}/stories/1")).to be(true)
    end
  end

  describe 'loading collections' do
    let(:attrs) {
      {
        name: 'My New Project',
        url: 'github.com/baccigalupi/my-new-project',
        description: '#Headline!'
      }
    }

    before do
      model.stories << Feature.new(name: 'Make it go', description: 'Do I have to specify this?')
      model.stories << Bug.new(name: 'It just doesn\'t work', description: 'Do I have to specify this?')
      model.save
    end

    let(:loaded_model) {
      project = Project.new(id: model.id)
      project.load
      project
    }

    it 'builds the right classes for collection models' do
      expect(loaded_model.stories.size).to eq(2)
      expect(loaded_model.stories.first.model).to be_a(Feature)
      expect(loaded_model.stories.last.model).to be_a(Bug)
    end
  end

  context 'in order to have the models work well in forms for ActiveModel' do
    let(:naming) { double('naming class') }

    it 'shortens the name' do
      expect(ActiveModel::Name).to receive(:new).with(Nested::Deeply::Is::Project, Nested::Deeply::Is).and_return(naming)
      Nested::Deeply::Is::Project.model_name
    end
  end
end
