# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Source File
      #
      # SourceFile represents a list of source files that contain raw Tailwind CSS components
      class SourceFile < Dry::Struct
        attribute :name                           , Types::Strict::String
        attribute :file_name                      , Types::Strict::String
        attribute :file_name_only                 , Types::Strict::String
        attribute :absolute_file                  , Types::Strict::String
        attribute :file                           , Types::Strict::String
        attribute :target                         , TargetFile
      end
    end
  end
end
