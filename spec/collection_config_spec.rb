require 'spec_helper'

RSpec.describe Knish::CollectionConfig do
  let(:config) { Knish::CollectionConfig.new(model_config, path) }
  let(:model_config) { Project.config }
  let(:path) { 'stories' }

  let(:project_path) { full_db_path + '/projects/1' }
  let(:stories_path) { project_path + '/stories' }

  before do
    # setup file system of a collection
    FileUtils.mkdir_p(project_path + "/stories/1")
    File.open(project_path + "/data.json", 'w') {|f| f.write({name: 'hello project'}.to_json) }
    File.open(project_path + "/stories/1/data.json", 'w') {|f| f.write({name: 'hello feature', ___type: 'Feature'}.to_json) }
  end

  after { clear_db(full_db_path) }

  describe '#collection_root' do
    it 'should be based on the model config and the path' do
      expect(config.collection_root).to eq(stories_path)
    end
  end

  describe '#next_id' do
    it 'should be the next available id' do
      expect(config.next_id).to eq(2)
    end
  end

  describe '#memeber_config(klass, id)' do
    let(:member_config) { config.member_config(Bug.config, 2) }

    it 'should have the model attributes of the class' do
      expect(member_config.all_attributes).to eq(Bug.config.all_attributes)
    end

    it 'should have the path specific to this model' do
      expect(member_config.model_root).to eq(project_path + "/stories/2")
    end
  end
end
