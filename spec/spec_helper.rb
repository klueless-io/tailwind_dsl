# frozen_string_literal: true

require 'pry'
require 'bundler/setup'
require 'simplecov'
require 'support/use_temp_folder'

SimpleCov.start

require 'tailwind_dsl'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.filter_run_when_matching :focus

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
