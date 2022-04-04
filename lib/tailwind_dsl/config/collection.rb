# frozen_string_literal: true

module TailwindDsl
  module Config
    # Collection
    class Collection
      attr_accessor :name
      attr_accessor :description
      attr_accessor :component_groups
      attr_accessor :default_themes

      def initialize; end
    end
  end
end
