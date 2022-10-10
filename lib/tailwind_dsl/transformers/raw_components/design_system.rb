# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Design System
      #
      # DesignSystem represents a collection of Tailwind CSS components that follow a specific design system
      class DesignSystem < Dry::Struct
        attribute :name                           , Types::Strict::String
        attribute :path                           , Types::Strict::String
        # attribute :stats                          , Types::Strict::Hash

        attribute :groups?                         , Types::Strict::Array.of(Group).optional.default() { [] }

        def add_group(group)
          groups << group

          group
        end
      end
    end
  end
end
