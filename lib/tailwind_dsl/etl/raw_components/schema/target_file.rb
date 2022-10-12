# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Target File
      #
      # TargetFile represents each sub_file that can be built from a source file, such as HTML Component, Tailwind Config, Settings and Data Structure
      class TargetFile
        attr_accessor :html_file
        attr_accessor :clean_html_file
        attr_accessor :tailwind_config_file
        attr_accessor :settings_file
        attr_accessor :data_file
        attr_accessor :astro_file

        # rubocop:disable Metrics/ParameterLists
        def initialize(html_file:, clean_html_file:, tailwind_config_file:, settings_file:, data_file:, astro_file:)
          @html_file = html_file
          @clean_html_file = clean_html_file
          @tailwind_config_file = tailwind_config_file
          @settings_file = settings_file
          @data_file = data_file
          @astro_file = astro_file
        end
        # rubocop:enable Metrics/ParameterLists

        def to_h
          {
            html_file: html_file,
            clean_html_file: clean_html_file,
            tailwind_config_file: tailwind_config_file,
            settings_file: settings_file,
            data_file: data_file,
            astro_file: astro_file
          }
        end
      end
    end
  end
end
