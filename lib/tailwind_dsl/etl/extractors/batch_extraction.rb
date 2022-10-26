# frozen_string_literal: true

module TailwindDsl
  module Etl
    module Extractors
      # Extract component data an place into a nwe file using a an extractor.
      # Currently designed to work with GPT3 to infer some type of target structure.
      class BatchExtraction
        attr_reader :components
        attr_reader :target_root_path
        attr_reader :batch_size
        attr_reader :filter

        # Create comment for this initialize method

        # @param [Array] components list of components that can be used to extract data
        # @param [String] target_root_path root directory where the extracted data will be written to, this is the root path for all design systems and groups
        # @param [Hash] args
        # @option args [Integer] :batch_size number of components to process, default is 1
        # @option args [Hash] :filter filter components before processing
        #                             design_system: name of the design system to filter on, default is nil meaning all
        # @option args [Class] :extract_handler class that implements an extract method
        def initialize(components, target_root_path, **args)
          @components = components
          @target_root_path = target_root_path
          @batch_size = args[:batch_size] || 1
          @filter = args[:filter] || nil
          @extract_handler = args[:extract_handler]
        end

        # rubocop:disable Metrics/AbcSize
        def extract
          raise "Batch size must be greater than 0, got: #{batch_size}" if batch_size <= 0

          remaining = batch_size

          filter_components.each do |component|
            component_guard(component)

            extractor.component = component

            next if File.exist?(extractor.target_file)

            component.debug
            extractor.extract

            remaining -= 1
            break if remaining.zero?
          end
        end
        # rubocop:enable Metrics/AbcSize

        def extractor
          return @extractor if defined? @extractor

          raise 'Extract handler is required' unless @extract_handler

          @extractor = @extract_handler.new

          raise 'Extract handler must implement extract method' unless @extractor.respond_to?(:extract)
          raise 'Extract handler must implement target_file method' unless @extractor.respond_to?(:target_file)

          @extractor
        end

        private

        def component_guard(component)
          path = File.join(component.design_system.target_path, component.group.folder)
          raise "Folder does not exist: '#{path}', make sure you run component structure generator first." unless File.exist?(path)
        end

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
        def filter_components
          return components unless filter

          result = components
          # inclusions
          result = result.select { |component| component.design_system.name == filter[:design_system] }     if filter[:design_system]
          result = result.select { |component| component.group.key == filter[:group_key] }                  if filter[:group_key]
          # exclusions
          result = result.reject { |component| component.group.key == filter[:exclude_group_key] }          if filter[:exclude_group_key]
          result
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
      end
    end
  end
end
