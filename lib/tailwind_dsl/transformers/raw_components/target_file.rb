# frozen_string_literal: true

module TailwindDsl
  module Transformers
    module RawComponents
      # Target File
      #
      # TargetFile represents each sub_file that can be built from a source file, such as HTML Component, Tailwind Config, Settings and Data Structure
      class TargetFile < Dry::Struct
        attribute :html_file                      , Types::Strict::String
        attribute :clean_html_file                , Types::Strict::String
        attribute :tailwind_config_file           , Types::Strict::String
        attribute :settings_file                  , Types::Strict::String
        attribute :data_file                      , Types::Strict::String
        attribute :astro_file                     , Types::Strict::String
      end
    end
  end
end
