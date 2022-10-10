# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Root
      #
      # Root container for normalizing the raw Tailwind html in component data structures
      class Root < Dry::Struct
        attribute :design_systems , Types::Strict::Array.of(DesignSystem)
      end
    end
  end
end
