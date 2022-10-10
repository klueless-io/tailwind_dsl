# frozen_string_literal: true

module TailwindDsl
  module RawComponents
    # Component Graph will store a JSON representation of the Design System components.
    #
    # This is a raw representation of the source.
    #
    # This data structure will be used by the component transformer to build
    # auxiliary data structures for components such as clean HTML, Astro, data shapes.
    class ComponentGraph
      attr_reader :design_systems

      def initialize
        @design_systems = {}
      end

      def add_design_system(path, name: nil)
        name = (name || File.basename(path)).to_s

        a = ComponentReader.build(name, path)
        @design_systems[name] = a
      end

      def design_system(name)
        @design_systems[name.to_s]
      end

      def design_system?(name)
        @design_systems.key?(name)
      end

      def to_h
        @design_systems
      end

      def write(file)
        FileUtils.mkdir_p(File.dirname(file))
        File.write(file, JSON.pretty_generate(to_h))
      end
    end
  end
end
