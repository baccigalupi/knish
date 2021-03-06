require 'spec_helper'

RSpec.describe Knish::Reader do
  let(:reader) { Knish::Reader.new(config) }
  let(:config) {
    c = Knish::ModelConfig.new(fixture_db_config, 'posts', id)
    c.markdown_attributes = ['key']
    c
  }
  let(:id) { 32 }

  before { clear_db(db_fixture_path) }
  after  { clear_db(db_fixture_path) }

  context 'when the collection directory does not exist' do
    it '#get_json returns an empty hash' do
      expect(reader.get_json).to eq({})
    end

    it '#get_markdown returns an empty string' do
      expect(reader.get_markdown).to eq({'key' => ''})
    end

    it '#template returns the path as though it were there' do
      expect(reader.template('key')).to eq("/../../knish/posts/32/key")
    end

    it 'should not be persisted' do
      expect(reader.persisted?).to eq(false)
    end
  end

  context 'when the data exists' do
    before do
      FileUtils.mkdir_p(config.model_root)
      File.open("#{config.model_root}/data.json", 'w') {|f| f.write({hello: 'happy json'}.to_json)}
      File.open("#{config.model_root}/_key.md", 'w') {|f| f.write("#hello!")}
    end

    it '#get_json returns the found data' do
      expect(reader.get_json).to eq({'hello' => 'happy json'})
    end

    it '#get_markdown returns the contents of the file' do
      expect(reader.get_markdown).to eq({'key' =>"#hello!"})
    end

    it '#template returns the path to the markdown file, rails style' do
      expect(reader.template('key')).to eq("/../../knish/posts/32/key")
    end

    it 'should be persisted' do
      expect(reader.persisted?).to eq(true)
    end
  end
end
