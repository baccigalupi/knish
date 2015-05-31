Project = Knish.build('projects') do |config|
  config.db_directory = db_fixture_path
  config.data_attributes = ['name', 'url']
  config.markdown_attributes = ['description']
  config.collections = ['stories']
end

Feature = Knish.build('features') do |config|
  config.db_directory = db_fixture_path
  config.data_attributes = ['name']
  config.markdown_attributes = ['overview', 'description', 'scenarios']
end

Bug = Knish.build('bugs') do |config|
  config.db_directory = db_fixture_path
  config.data_attributes = ['name']
  config.markdown_attributes = ['description', 'reproduction_steps', 'expected', 'actual', 'additional_information']
end

module Nested
  module Deeply
    module Is
      Project = Knish.build('projects') do |config|
        config.db_directory = db_fixture_path
        config.data_attributes = ['name', 'url']
        config.markdown_attributes = ['description']
        config.collections = ['stories']
      end

      class Project
        def self.omitted_namespace
          Nested::Deeply::Is
        end
      end
    end
  end
end
