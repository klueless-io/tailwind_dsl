# frozen_string_literal: true

RSpec.shared_context :use_temp_folder do
  attr_reader :temp_folder

  around do |example|
    Dir.mktmpdir('rspec-') do |folder|
      @temp_folder = folder
      example.run
    end
  end
end
