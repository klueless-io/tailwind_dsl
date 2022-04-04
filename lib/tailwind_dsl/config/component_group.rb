# frozen_string_literal: true

module TailwindDsl
  module Config
    # Component Group
    class ComponentGroup
      attr_accessor :key
      attr_accessor :name
      attr_accessor :description
      attr_accessor :collection
      attr_accessor :components

      def initialize; end
    end
  end
end
