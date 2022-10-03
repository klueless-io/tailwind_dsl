# frozen_string_literal: true

module TailwindDsl
  class RawComponentGraph
    attr_reader :ui_kits

    def initialize
      @ui_kits = {}
    end

    def add_ui_kit(path, name)
      @ui_kits[name] = {
        name: name,
        path: path
      }
    end

    def ui_kit(name)
      @ui_kits[name]
    end

    private
  end
end
