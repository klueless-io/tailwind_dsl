# frozen_string_literal: true

module TailwindDsl
  module Etl
    module ComponentStructures
      # Raw Component Query will return a list of raw components that are available for processing
      #
      # This is a two pass process:
      #  1. Query the raw component folder for all files that match the pattern and build up a graph with required information

      # puts '%-20s %s' % ['name', name]
      # puts '%-20s %s' % ['source_path', source_path]
      # puts '%-20s %s' % ['target_path', target_path]
      #  2. Flatten the graph into a list of rows
      class RawComponentQuery
        DesignSystem = Struct.new(:name, :source_path, :target_path, keyword_init: true) do
          def debug
            puts format('%-30<key>s : %<value>s', key: 'Design system', value: name)
            puts format('%-30<key>s : %<value>s', key: 'Source path', value: source_path)
            puts format('%-30<key>s : %<value>s', key: 'Target path', value: target_path)
          end
        end

        Group = Struct.new(:key, :type, :sub_keys, :folder, keyword_init: true) do
          def debug
            puts format('%-30<key>s : %<value>s', key: 'Group key', value: key)
            puts format('%-30<key>s : %<value>s', key: 'Group type', value: type)
            puts format('%-30<key>s : %<value>s', key: 'Group sub keys', value: sub_keys)
            puts format('%-30<key>s : %<value>s', key: 'Group folder', value: folder)
          end
        end

        FilePath = Struct.new(
          :source_file,
          :target_html_file,
          :target_clean_html_file,
          :target_tailwind_config_file,
          :target_settings_file,
          :target_data_file,
          :target_model_file,
          :target_astro_file,
          keyword_init: true
        ) do
          # rubocop:disable Metrics/AbcSize
          def debug
            puts format('%-30<key>s : %<value>s', key: 'Source file', value: source_file)
            puts format('%-30<key>s : %<value>s', key: 'Target html file', value: target_html_file)
            puts format('%-30<key>s : %<value>s', key: 'Target clean html file', value: target_clean_html_file)
            puts format('%-30<key>s : %<value>s', key: 'Target tailwind config file', value: target_tailwind_config_file)
            puts format('%-30<key>s : %<value>s', key: 'Target settings file', value: target_settings_file)
            puts format('%-30<key>s : %<value>s', key: 'Target data file', value: target_data_file)
            puts format('%-30<key>s : %<value>s', key: 'Target model file', value: target_model_file)
            puts format('%-30<key>s : %<value>s', key: 'Target astro file', value: target_astro_file)
          end
          # rubocop:enable Metrics/AbcSize
        end

        class Component
          attr_reader :name
          attr_reader :design_system
          attr_reader :group
          attr_reader :absolute
          attr_reader :relative

          # Storage buckets for data that is extracted from the source file
          attr_accessor :captured_comment_text
          attr_accessor :captured_comment_list
          attr_accessor :captured_tailwind_config

          def initialize(name:, design_system:, group:, absolute:, relative:)
            @name = name
            @design_system = design_system
            @group = group
            @absolute = absolute
            @relative = relative
          end

          def to_h
            {
              name: name,
              design_system: design_system.to_h,
              group: group.to_h,
              absolute: absolute.to_h,
              relative: relative.to_h
            }
          end

          def debug
            puts format('%-30<key>s : %<value>s', key: 'Component', value: name)
            design_system.debug
            group.debug
            puts ':: Absolute paths'
            absolute.debug
            puts '::Relative paths'
            relative.debug
          end
        end

        attr_reader :uikit
        # Location for raw components
        attr_reader :source_root_path
        # Location for component structures
        attr_reader :target_root_path
        attr_reader :current_design_system
        attr_reader :components

        def initialize(uikit, **args)
          @uikit = uikit
          @source_root_path = args[:source_root_path] || raise(ArgumentError, 'Missing source_root_path')
          @target_root_path = args[:target_root_path] || raise(ArgumentError, 'Missing target_root_path')
        end

        class << self
          def query(uikit, source_root_path:, target_root_path:)
            instance = new(uikit, source_root_path: source_root_path, target_root_path: target_root_path)
            instance.call
          end
        end

        def call
          @components = build_components

          self
        end

        # Flattened list of components in hash format
        # @return [Array<Hash>] list
        def to_h
          components.map(&:to_h)
        end

        private

        # rubocop:disable Metrics/AbcSize
        def build_components
          uikit.design_systems.flat_map do |design_system|
            @current_design_system = design_system
            design_system.groups.flat_map do |group|
              group.files.map do |file|
                Component.new(
                  name: file.file_name_only,
                  design_system: DesignSystem.new(**map_design_system),
                  group: Group.new(**map_group(group)),
                  absolute: FilePath.new(**map_absolute_file(file)),
                  relative: FilePath.new(**map_relative_file(file))
                )
              end
            end
          end
        end
        # rubocop:enable Metrics/AbcSize

        def design_system_name
          current_design_system.name
        end

        def source_path
          File.join(source_root_path, design_system_name)
        end

        def target_path
          File.join(target_root_path, design_system_name)
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
            target_model_file: file.target.model_file,
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
            target_model_file: File.join(target_path, file.target.model_file),
            target_astro_file: File.join(target_path, file.target.astro_file)
          }
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
