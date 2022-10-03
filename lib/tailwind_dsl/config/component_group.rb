# frozen_string_literal: true

module TailwindDsl
  module Config
    # Component Group
    #
    # Configuration for component group. [nav, footer, header, hero, price]
    class ComponentGroup
      attr_accessor :key
      attr_accessor :name
      attr_accessor :description
      attr_accessor :collection
      attr_accessor :components
    end
  end
end
