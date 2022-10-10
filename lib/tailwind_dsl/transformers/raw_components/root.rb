# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Root
      #
      # Root container for normalizing the raw Tailwind html in component data structures
      class Root
        attr_accessor :design_systems

        def initialize(design_systems: [])
          @design_systems = design_systems
        end

        def add_design_system(design_system)
          design_systems << design_system

          design_system
        end

        def to_h
          {
            design_systems: design_systems.map(&:to_h)
          }
        end
      end
    end
  end
end
