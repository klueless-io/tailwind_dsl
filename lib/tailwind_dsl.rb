# frozen_string_literal: true

require_relative 'tailwind_dsl/version'
require_relative '_'

module TailwindDsl
  # raise TailwindDsl::Error, 'Sample message'
  Error = Class.new(StandardError)

  # Your code goes here...
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'TailwindDsl::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('tailwind_dsl/version') }
  version   = TailwindDsl::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
