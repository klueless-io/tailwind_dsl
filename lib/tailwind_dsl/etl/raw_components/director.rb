# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # NOTE: Director is badly named.

      # Use the Director to build the UiKit which will store the JSON representations of each Design System plus components.
      #
      # This is a raw representation of the source.
      #
      # This data structure will be used by the component transformer to build
      # auxiliary data structures for components such as clean HTML, Astro, data shapes.
      class Director
        attr_reader :uikit

        def initialize
          @uikit = ::TailwindDsl::Etl::RawComponents::UiKit.new
        end

        def add_design_system(path, name: nil)
          name = (name || File.basename(path)).to_s

          design_system = Transformer.new.call(name, path)

          uikit.add_design_system(design_system)
        end

        def write(file)
          FileUtils.mkdir_p(File.dirname(file))
          File.write(file, JSON.pretty_generate(uikit.to_h))
        end
      end
    end
  end
end
