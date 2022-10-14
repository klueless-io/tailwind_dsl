# frozen_string_literal: true

module TailwindDsl
  module Etl
    module ComponentStructures
      # Raw Component Query will return a list of raw components that are available for processing
      #
      # This is a two pass process:
      #  1. Query the raw component folder for all files that match the pattern and build up a graph with required information
      #  2. Flatten the graph into a list of rows
      #
      # If you need to debug, then pass in the debug flag and it will output the graph to the console
      class RawComponentQuery
        DesignSystem = Struct.new(
          :name,
          :source_path,
          :target_path,
          keyword_init: true
        )

        Group = Struct.new(
          :key,
          :type,
          :sub_keys,
          :folder,
          keyword_init: true
        )
        FilePath = Struct.new(
          :source_file,
          :target_html_file,
          :target_clean_html_file,
          :target_tailwind_config_file,
          :target_settings_file,
          :target_data_file,
          :target_astro_file, keyword_init: true
        )

        class Record
          attr_reader :design_system
          attr_reader :group
          attr_reader :absolute_path
          attr_reader :relative_path

          # Storage buckets for data that is extracted from the source file
          attr_accessor :captured_comment_text
          attr_accessor :captured_comment_list
          attr_accessor :captured_tailwind_config

          def initialize(design_system:, group:, absolute_path:, relative_path:)
            @design_system = design_system
            @group = group
            @absolute_path = absolute_path
            @relative_path = relative_path
          end

          def to_h
            {
              design_system: design_system.to_h,
              group: group.to_h,
              absolute_path: absolute_path.to_h,
              relative_path: relative_path.to_h
            }
          end
        end

        attr_reader :uikit
        attr_reader :raw_component_root_path
        attr_reader :component_structure_root_path
        attr_reader :current_design_system
        attr_reader :debug
        attr_reader :records

        def initialize(uikit, **args)
          @uikit = uikit
          @raw_component_root_path = args[:raw_component_root_path] || raise(ArgumentError, 'Missing raw_component_root_path')
          @component_structure_root_path = args[:component_structure_root_path] || raise(ArgumentError, 'Missing component_structure_root_path')
          @debug = args[:debug] || false
        end

        class << self
          def query(uikit, raw_component_root_path:, component_structure_root_path:, debug: false)
            instance = new(uikit, raw_component_root_path: raw_component_root_path, component_structure_root_path: component_structure_root_path, debug: debug)
            instance.call
          end
        end

        def call
          @records = build_records

          self
        end

        # Flattened list of records in hash format
        # @return [Array<Hash>] list
        def to_h
          records.map(&:to_h)
        end

        private

        def build_records
          uikit.design_systems.flat_map do |design_system|
            @current_design_system = design_system
            design_system.groups.flat_map do |group|
              group.files.map do |file|
                Record.new(
                  design_system: DesignSystem.new(**map_design_system),
                  group: Group.new(**map_group(group)),
                  absolute_path: FilePath.new(**map_absolute_file(file)),
                  relative_path: FilePath.new(**map_relative_file(file))
                )
              end
            end
          end
        end

        def design_system_name
          current_design_system.name
        end

        def source_path
          File.join(raw_component_root_path, design_system_name)
        end

        def target_path
          File.join(component_structure_root_path, design_system_name)
        end

        def map_design_system
          {
            name: design_system_name,
            source_path: source_path,
            target_path: target_path
          }
        end

        def map_group(group)
          {
            key: group.key,
            type: group.type,
            sub_keys: group.sub_keys,
            folder: group.folder
          }
        end

        def map_relative_file(file)
          {
            source_file: file.file,
            target_html_file: file.target.html_file,
            target_clean_html_file: file.target.clean_html_file,
            target_tailwind_config_file: file.target.tailwind_config_file,
            target_settings_file: file.target.settings_file,
            target_data_file: file.target.data_file,
            target_astro_file: file.target.astro_file
          }
        end

        # rubocop:disable Metrics/AbcSize
        def map_absolute_file(file)
          {
            source_file: File.join(source_path, file.file),
            target_html_file: File.join(target_path, file.target.html_file),
            target_clean_html_file: File.join(target_path, file.target.clean_html_file),
            target_tailwind_config_file: File.join(target_path, file.target.tailwind_config_file),
            target_settings_file: File.join(target_path, file.target.settings_file),
            target_data_file: File.join(target_path, file.target.data_file),
            target_astro_file: File.join(target_path, file.target.astro_file)
          }
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
