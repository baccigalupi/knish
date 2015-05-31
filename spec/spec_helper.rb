$: << File.dirname(__FILE__) + "/../lib"
require 'knish'

Dir.glob(File.dirname(__FILE__) + "/support/**/*").each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed

  config.before {
    Knish.clear_config
    Knish.configure do |c|
      c.db_directory = db_fixture_path
    end
  }
end
