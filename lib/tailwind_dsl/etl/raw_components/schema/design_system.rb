# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Design System
      #
      # DesignSystem represents a collection of Tailwind CSS components that follow a specific design system
      class DesignSystem < TailwindDsl::Etl::Element
        attr_accessor :name
        attr_accessor :stats
        attr_accessor :groups

        def initialize(**args)
          @name = grab_arg(args, :name, guard: 'Missing name')
          @stats = grab_arg(args, :stats, default: {})
          @groups = grab_arg(args, :groups, default: []).map { |group| map_to(Group, group) }.compact
        end

        def add_group(group)
          add_to_list(Group, groups, group)
        end

        def to_h
          {
            name: name,
            stats: stats,
            groups: groups.map(&:to_h)
          }
        end
      end
    end
  end
end
