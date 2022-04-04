# frozen_string_literal: true

module TailwindDsl
  module Schema
    # Component
    class Component
      attr_accessor :key
      attr_accessor :name
      attr_accessor :description
      attr_accessor :component_group
      attr_accessor :data_shape

      def initialize; end
    end
  end
end
