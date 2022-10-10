# frozen_string_literal: true

require 'cmdlet'
require 'dry-struct'

module Types
  include Dry.Types()
end

require_relative 'tailwind_dsl/version'
require_relative '_'
require_relative 'tailwind_dsl/raw_components/component_graph'
require_relative 'tailwind_dsl/raw_components/component_reader'
require_relative 'tailwind_dsl/raw_components/data'
require_relative 'tailwind_dsl/raw_components/generate_component_structures'

require_relative 'tailwind_dsl/transformers/raw_components/target_file'
require_relative 'tailwind_dsl/transformers/raw_components/source_file'
require_relative 'tailwind_dsl/transformers/raw_components/group'
require_relative 'tailwind_dsl/transformers/raw_components/design_system'
require_relative 'tailwind_dsl/transformers/raw_components/root'

# require_relative 'tailwind_dsl/component_structure/data'
# require_relative 'tailwind_dsl/component_structure/generate_component_structures'
# require_relative 'tailwind_dsl/astro_demo/generate_astro_page_data'

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
