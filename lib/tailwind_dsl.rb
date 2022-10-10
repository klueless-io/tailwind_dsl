# frozen_string_literal: true

require 'cmdlet'

require_relative 'tailwind_dsl/version'
require_relative '_'
require_relative 'tailwind_dsl/raw_components/component_graph'
require_relative 'tailwind_dsl/raw_components/component_reader'
require_relative 'tailwind_dsl/raw_components/data'
require_relative 'tailwind_dsl/raw_components/generate_component_structures'

require_relative 'tailwind_dsl/transformers/raw_components/raw_component_director'
require_relative 'tailwind_dsl/transformers/raw_components/raw_component_transformer'
require_relative 'tailwind_dsl/transformers/raw_components/schema/target_file'
require_relative 'tailwind_dsl/transformers/raw_components/schema/source_file'
require_relative 'tailwind_dsl/transformers/raw_components/schema/group'
require_relative 'tailwind_dsl/transformers/raw_components/schema/design_system'
require_relative 'tailwind_dsl/transformers/raw_components/schema/root'

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
