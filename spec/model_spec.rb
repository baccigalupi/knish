require 'spec_helper'

RSpec.describe Knish::Model do
  let(:model) { model_class.new(attrs) }

  let(:model_class) do
    Knish.build(path) do |config|
      config.db_directory = db_fixture_path
    end
  end

  let(:config) do
    Knish::ModelConfig.new(fixture_db_config, path, id)
  end

  let(:path) { 'projects' }

  let(:attrs) { {} }
  let(:id) { nil }

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
    let(:model_class) do
      Knish.build(path) do |config|
        config.db_directory = db_fixture_path
        config.data_attributes = ['name', 'url']
        config.markdown_attributes = ['description']
        config.collections = ['stories']
      end
    end

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
end
