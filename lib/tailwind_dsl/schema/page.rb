# frozen_string_literal: true

module TailwindDsl
  module Schema
    # Page
    class Page
      attr_accessor :key
      attr_accessor :name
      attr_accessor :description
      attr_accessor :sub_folder
      attr_accessor :level
      attr_accessor :pages
      attr_accessor :components

      def initialize; end
    end
  end
end
