# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Design System
      #
      # DesignSystem represents a collection of Tailwind CSS components that follow a specific design system
      class DesignSystem
        attr_accessor :name
        # attr_accessor :path
        attr_accessor :stats
        attr_accessor :groups

        # , path:
        def initialize(name:, stats: {}, groups: [], **_args)
          @name = name
          # @path = path
          @stats = stats

          @groups = []
          groups.each { |group| add_group(group) }
        end

        def add_group(group)
          add = convert_group(group)

          return nil if add.nil?

          groups << add

          add
        end

        # path: path,
        def to_h
          {
            name: name,
            stats: stats,
            groups: groups.map(&:to_h)
          }
        end

        private

        def convert_group(group)
          return nil if group.nil?

          return group if group.is_a?(Group)
          return Group.new(group) if group.is_a?(Hash)

          puts "Unknown group type: #{group.class}"
          nil
        end
      end
    end
  end
end