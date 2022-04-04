# frozen_string_literal: true

module TailwindDsl
  module Schema
    # Web Site
    class WebSite
      attr_accessor :key
      attr_accessor :name
      attr_accessor :description
      attr_accessor :target_folder
      attr_accessor :base_collection
      attr_accessor :theme
      attr_accessor :root

      def initialize; end

      def favourite_components; end
    end
  end
end
