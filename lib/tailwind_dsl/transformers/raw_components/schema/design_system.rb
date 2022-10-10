# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Design System
      #
      # DesignSystem represents a collection of Tailwind CSS components that follow a specific design system
      class DesignSystem
        attr_accessor :name
        attr_accessor :path
        attr_accessor :stats
        attr_accessor :groups

        def initialize(name:, path:, stats: {}, groups: [])
          @name = name
          @path = path
          @stats = stats
          @groups = groups
        end

        def add_group(group)
          groups << group

          group
        end

        def to_h
          {
            name: name,
            path: path,
            stats: stats,
            groups: groups.map(&:to_h)
          }
        end
      end
    end
  end
end
