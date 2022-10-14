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

        ComponentGroup = Struct.new(
          :key,
          :type,
          :sub_keys,
          :folder,
          keyword_init: true
        )
        ComponentInfo = Struct.new(
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
          attr_reader :component_group
          attr_reader :absolute_component
          attr_reader :relative_component

          def initialize(design_system:, component_group:, absolute_component:, relative_component:)
            @design_system = design_system
            @component_group = component_group
            @absolute_component = absolute_component
            @relative_component = relative_component
          end

          def to_h
            {
              design_system: design_system.to_h,
              component_group: component_group.to_h,
              absolute_component: absolute_component.to_h,
              relative_component: relative_component.to_h
            }
          end
        end

        attr_reader :uikit
        attr_reader :raw_component_root_path
        attr_reader :component_structure_root_path
        attr_reader :current_design_system
        attr_reader :debug

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
          run_query
          # puts JSON.pretty_generate(graph) if debug
          # {
          #   list: list.map(&:to_h)
          # }
          self
        end

        # Flattened list of records in hash format
        # @return [Array<Hash>] list
        def to_h
          @list.map(&:to_h)
        end

        # Flattened list of records
        #
        # @return [Array<Record>] list
        def records
          @list
        end

        # Graph hierarchy is kept in deep nested format
        #
        # @return [Array<Hash>] graph
        def graph
          return @graph if defined? @graph

          @graph = build_graph
        end

        private

        def build_graph
          uikit.design_systems.map do |design_system|
            @current_design_system = design_system
            map_design_system
          end
        end

        def map_design_system
          {
            name: current_design_system.name,
            source_path: source_path,
            target_path: target_path,
            groups: current_design_system.groups.map do |group|
              map_group(group)
            end
          }
        end

        def map_group(group)
          {
            key: group.key,
            type: group.type,
            sub_keys: group.sub_keys,
            files: group.files.map do |file|
              map_file(file)
            end
          }
        end

        # rubocop:disable Metrics/AbcSize
        def map_file(file)
          {
            relative: {
              source_file: file.file,
              target_html_file: file.target.html_file,
              target_clean_html_file: file.target.clean_html_file,
              target_tailwind_config_file: file.target.tailwind_config_file,
              target_settings_file: file.target.settings_file,
              target_data_file: file.target.data_file,
              target_astro_file: file.target.astro_file
            },
            absolute: {
              source_file: File.join(source_path, file.file),
              target_html_file: File.join(target_path, file.target.html_file),
              target_clean_html_file: File.join(target_path, file.target.clean_html_file),
              target_tailwind_config_file: File.join(target_path, file.target.tailwind_config_file),
              target_settings_file: File.join(target_path, file.target.settings_file),
              target_data_file: File.join(target_path, file.target.data_file),
              target_astro_file: File.join(target_path, file.target.astro_file)
            }
          }
        end
        # rubocop:enable Metrics/AbcSize

        def design_system_name
          current_design_system.name
        end

        def source_path
          File.join(raw_component_root_path, current_design_system.name)
        end

        def target_path
          File.join(component_structure_root_path, current_design_system.name)
        end

        def run_query
          @list = graph.flat_map do |design_system|
            design_system[:groups].flat_map do |group|
              group[:files].map do |file|
                Record.new(
                  design_system: DesignSystem.new(**design_system.slice(:name, :source_path, :target_path)),
                  component_group: ComponentGroup.new(**group.slice(:key, :type, :sub_keys)),
                  absolute_component: ComponentInfo.new(**file[:absolute]),
                  relative_component: ComponentInfo.new(**file[:relative])
                )
              end
            end
          end
        end
      end
    end
  end
end
