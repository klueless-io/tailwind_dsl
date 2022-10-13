# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Target File
      #
      # TargetFile represents each sub_file that can be built from a source file, such as HTML Component, Tailwind Config, Settings and Data Structure
      class TargetFile < TailwindDsl::Etl::Element
        attr_accessor :html_file
        attr_accessor :clean_html_file
        attr_accessor :tailwind_config_file
        attr_accessor :settings_file
        attr_accessor :data_file
        attr_accessor :astro_file

        def initialize(**args)
          @html_file = grab_arg(args, :html_file, guard: 'Missing html_file')
          @clean_html_file = grab_arg(args, :clean_html_file, guard: 'Missing clean_html_file')
          @tailwind_config_file = grab_arg(args, :tailwind_config_file, guard: 'Missing tailwind_config_file')
          @settings_file = grab_arg(args, :settings_file, guard: 'Missing settings_file')
          @data_file = grab_arg(args, :data_file, guard: 'Missing data_file')
          @astro_file = grab_arg(args, :astro_file, guard: 'Missing astro_file')
        end

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
