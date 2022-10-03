# frozen_string_literal: true

module TailwindDsl
  module Config
    # Collection
    #
    # Configuration for collection of Tailwind components. AKA uikit / brands / set / design
    class Collection
      attr_accessor :name
      attr_accessor :description
      attr_accessor :component_groups
      attr_accessor :default_themes
    end
  end
end
