require 'spec_helper'

RSpec.describe Knish, '.configure' do
  before { Knish.clear_config }

  it 'allows the configuration any values in the global config' do
    Knish.configure do |config|
      config.db_directory = db_fixture_path
      config.view_to_db_path = 'view_to_db_path'
      config.data_filename = 'my-data.json'
      config.db_name = 'my-db'
    end

    expect(Knish.config.db_directory).to eq(db_fixture_path)
    expect(Knish.config.view_to_db_path).to eq('view_to_db_path')
    expect(Knish.config.data_filename).to eq('my-data.json')
    expect(Knish.config.db_name).to eq('my-db')
  end

  it 'uses a set of default values if not configured' do
    expect(Knish.config.view_to_db_path).to eq('/../..')
    expect(Knish.config.data_filename).to eq('data.json')
    expect(Knish.config.db_name).to eq('knish')
  end

  it 'constructs the database root from the db directory and the db name' do
    Knish.configure do |config|
      config.db_directory = 'db_dir'
      config.db_name = 'my-db'
    end

    expect(Knish.config.root).to eq('db_dir/my-db')
  end
end
