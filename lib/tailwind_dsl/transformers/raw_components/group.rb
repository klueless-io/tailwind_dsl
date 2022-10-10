# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Group
      #
      # Group represents a collection of Tailwind CSS components withing a named group or category
      class Group < Dry::Struct
        attribute :key                            , Types::Strict::String
        attribute :type                           , Types::Strict::String
        attribute :folder                         , Types::Strict::String
        attribute :sub_keys                       , Types::Array.of(Types::Strict::String)

        # Default value needs to be a proc to avoid sharing the same array across groups
        attribute :files?                         , Types::Strict::Array.of(SourceFile).optional.default() { [] }

        def add_file(file)
          files << file

          file
        end
      end
    end
  end
end
