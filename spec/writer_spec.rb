require 'spec_helper'

RSpec.describe Knish::Writer do
  let(:writer) { Knish::Writer.new(config, id) }
  let(:config) { Knish::ModelConfig.new(fixture_db_config, 'posts') }
  let(:id) { 32 }

  before { clear_db(db_fixture_path) }
  after { clear_db(db_fixture_path) }

  describe '#build_directories' do
    it 'will create the collection root directory' do
      writer.build_directories([])
      expect(File.exist?(config.model_root)).to eq(true)
    end

    it 'will create directories specified' do
      writer.build_directories(['foo', 'bar'])
      expect(File.exist?("#{config.model_root}/foo")).to eq(true)
      expect(File.exist?("#{config.model_root}/bar")).to eq(true)
    end
  end

  describe '#save_json' do
    it 'will build the root if it does not exist' do
      writer.save_json({})
      expect(File.exist?(config.model_root)).to eq(true)
    end

    it 'creates a data.json file in the root directory' do
      writer.save_json({})
      expect(File.exist?("#{config.model_root}/data.json")).to eq(true)
    end

    it 'has the right data' do
      writer.save_json({hello: 'knish'})
      data = JSON.load(File.read("#{config.model_root}/data.json"))
      expect(data).to eq({'hello' => 'knish'})
    end
  end

  describe '#save_markdown' do
    it 'will build the root if it does not exist' do
      writer.save_markdown({description: '#Description'})
      expect(File.exist?(config.model_root)).to eq(true)
    end

    it 'creates file with named for the key' do
      writer.save_markdown({description: '#Description'})
      expect(File.exist?("#{config.model_root}/_description.md")).to eq(true)
    end

    it 'has the markdown' do
      writer.save_markdown({description: '#Description'})
      data = File.read("#{config.model_root}/_description.md")
      expect(data).to eq('#Description')
    end
  end
end
