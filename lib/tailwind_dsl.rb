# frozen_string_literal: true

require_relative 'tailwind_dsl/version'
require_relative '_'
require_relative 'tailwind_dsl/raw_component_graph'

module TailwindDsl
  # raise TailwindDsl::Error, 'Sample message'
  Error = Class.new(StandardError)

  # Your code goes here...
end

if ENV.fetch('KLUE_DEBUG', 'false').downcase == 'true'
  namespace = 'TailwindDsl::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('tailwind_dsl/version') }
  version   = TailwindDsl::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
