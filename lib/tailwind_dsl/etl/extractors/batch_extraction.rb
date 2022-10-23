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
        attr_reader :use_prompt
        attr_reader :filter_design_system # this should be renamed and reshaped to a complex filter object

        # Create comment for this initialize method

        # @param [Array] components list of components that can be used to extract data
        # @param [String] target_root_path root directory where the extracted data will be written to, this is the root path for all design systems and groups
        # @param [Hash] args
        # @option args [Integer] :batch_size number of components to process, default is 1
        # @option args [Boolean] :use_prompt console based prompt so the user can guide the extractor, default is false
        # @option args [String] :filter_design_system name of the design system to filter on, default is nil meaning all
        # @option args [Class] :extract_handler class that implements an extract method
        def initialize(components, target_root_path, **args)
          @components = components
          @target_root_path = target_root_path
          @batch_size = args[:batch_size] || 1
          @use_prompt = args[:use_prompt] || false
          @filter_design_system = args[:filter_design_system] || nil
          @extract_handler = args[:extract_handler]
        end

        # Goal:       Extract the next (batch_size) component models using GPT3 and save them to target_root_path
        #             Create a data file at: design_system.name -> group-hierarchy -> component-name.data.json
        #             Create a model file at: design_system.name -> group-hierarchy -> component-name.model.rb

        # Process:    Collect all components and optionally filter them by design system name.
        #             Also filter by other keys (to be determined)
        #             Only process files that have not been processed before.
        #             Look for the next component to be processed, if it does not exist in the target folder then process it.
        #             decrement the batch_left counter and continue until batch_left is 0.
        #             if :use_prompt is true then display the input/output files and ask if you wish to process the component or skip.
        #             process the component by calling the GPT3 API and save the results to the target folder.

        def extract
          raise "Batch size must be greater than 0, got: #{batch_size}" if batch_size <= 0

          remaining = batch_size

          filter_components.each do |component|
            # puts "Processing: #{component.design_system.name} -> #{component.group.key} -> #{component.name} -> remaining#: #{remaining}"

            component_guard(component)
            extractor.component = component

            next if File.exist?(extractor.target_file)

            # if use_prompt
            #   puts "Input: #{component.cleansed_html_path}"
            #   puts "Output: #{component_model_path}"
            #   puts 'Process? (y/n)'
            #   next unless STDIN.gets.chomp == 'y'
            # end

            extractor.extract

            remaining -= 1
            break if remaining.zero?
          end
        end

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

        def filter_components
          return components unless filter_design_system

          components.select { |component| component.design_system.name == filter_design_system }
        end

        # def target_file(component)
        #   raise NotImplementedError, 'target_file is not implemented'
        # end
      end
    end
  end
end
