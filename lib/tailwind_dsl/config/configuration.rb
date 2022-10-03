# frozen_string_literal: true

module TailwindDsl
  module Config
    # Configuration
    #
    # Configuration container for the Tailwind DSL
    class Configuration
      attr_accessor :collections
      attr_accessor :themes
      attr_accessor :data_shapes
      attr_accessor :component_groups
    end
  end
end
