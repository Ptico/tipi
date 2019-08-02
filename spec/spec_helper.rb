if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'securerandom'

require 'tipi'

require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = false
  config.color = true

  if config.files_to_run.one?
    config.full_backtrace = true

    config.default_formatter = 'doc'
    config.profile_examples = 3
  end

  config.order = :random

  Kernel.srand config.seed
end
