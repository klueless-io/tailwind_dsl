# frozen_string_literal: true

module TailwindDsl
  module Etl
    module ComponentStructures
      # -----------------------------------------------------------------------------------------------
      # Internal Data Structure
      class Data
        attr_reader :design_system_name
        attr_reader :group                    # Component group information
        attr_reader :source                   # Source file information for the component
        attr_reader :target                   # Multiple target file information

        # Storage buckets for data that is extracted from the source file
        attr_accessor :captured_comment_text
        attr_accessor :captured_comment_list
        attr_accessor :captured_tailwind_config

        # rubocop:disable Metrics/AbcSize
        def initialize(design_system_name, group, file)
          @design_system_name = design_system_name

          @captured_comment_text = ''
          @captured_comment_list = []
          @captured_tailwind_config = ''

          @group = Group.new(key: group.key, type: group.type, sub_keys: group.sub_keys)
          @source = Source.new(file: file.absolute_file)
          @target = Target.new(
            folder: group.folder,
            html_file: file.target.html_file,
            clean_html_file: file.target.clean_html_file,
            tailwind_config_file: file.target.tailwind_config_file,
            settings_file: file.target.settings_file,
            data_file: file.target.data_file,
            astro_file: file.target.astro_file
          )
        end
        # rubocop:enable Metrics/AbcSize

        Group = Struct.new(:key, :type, :sub_keys, keyword_init: true)
        Source = Struct.new(:file, keyword_init: true) do
          def exist?
            File.exist?(file)
          end

          def content
            @content ||= File.exist?(file) ? File.read(file) : ''
          end
        end
        Target = Struct.new(:folder, :html_file, :clean_html_file, :tailwind_config_file, :settings_file, :data_file, :astro_file, keyword_init: true)
      end
    end
  end
end
