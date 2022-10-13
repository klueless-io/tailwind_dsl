# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # UiKit
      #
      # UiKit is a container for storing different tailwind design systems
      class UiKit
        attr_accessor :design_systems

        # Pass in a document with the keys symbolized
        #
        # JSON.parse(json, symbolize_names: true)
        #
        # @param document [Hash] the document to convert
        def initialize(document = nil)
          @design_systems = []

          return unless !document.nil? && document.is_a?(Hash) && document.key?(:design_systems) && document[:design_systems].is_a?(Array)

          document[:design_systems].each { |design_system| add_design_system(design_system) }
        end

        def add_design_system(design_system)
          add = convert_design_system(design_system)

          return nil if add.nil?

          add.name = add.name.to_s
          design_systems << add

          add
        end

        def design_system(name)
          find_name = name.to_s
          design_systems.find { |ds| ds.name == find_name }
        end

        def design_system?(name)
          !design_system(name).nil?
        end

        def to_h
          {
            design_systems: design_systems.map(&:to_h)
          }
        end

        private

        def convert_design_system(design_system)
          return nil if design_system.nil?

          return design_system if design_system.is_a?(DesignSystem)
          return DesignSystem.new(**design_system) if design_system.is_a?(Hash)

          puts "Unknown design_system type: #{design_system.class}"
          nil
        end
      end
    end
  end
end
