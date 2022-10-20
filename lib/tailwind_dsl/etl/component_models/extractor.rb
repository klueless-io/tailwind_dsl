# frozen_string_literal: true

module TailwindDsl
  module Etl
    module ComponentModels
      class Gpt3Extractor
        def extract_data(component)
          puts "extract data for #{component} using GPT3"
        end

        def extract_model(component)
          puts "extract model for #{component} using GPT3"
        end
      end

      # Extract component models by reading the cleansed component HTML and then using GPT3 to infer both the data/model structure.
      class Extractor
        attr_reader :components
        attr_reader :target_root_path
        attr_reader :batch_size
        attr_reader :batch_left
        attr_reader :use_prompt
        attr_reader :filter_design_system
        attr_reader :extract_handler

        def initialize(components, target_root_path, **args)
          @components = components
          @target_root_path = target_root_path
          @batch_size = args[:batch_size] || 1
          @batch_left = batch_size
          @use_prompt = args[:use_prompt] || false
          @filter_design_system = args[:filter_design_system] || nil
          @extract_handler = (args[:extract_handler] || Gpt3Extractor).new
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

        # rubocop:disable Metrics/AbcSize
        def extract
          guards

          filter_components.each do |component|
            puts "Processing: #{component.design_system.name} -> #{component.group.key} -> #{component.name} -> remaining#: #{batch_left}"

            component.debug
            # component_model_path = File.join(target_root_path, component.design_system.name, component.group_hierarchy, "#{component.name}.model.rb")
            # next if File.exist?(component_model_path)

            # if use_prompt
            #   puts "Input: #{component.cleansed_html_path}"
            #   puts "Output: #{component_model_path}"
            #   puts 'Process? (y/n)'
            #   next unless STDIN.gets.chomp == 'y'
            # end

            # puts "Processing: #{component_model_path}"

            # next if extract_handler

            # model = Gpt3::ComponentModel.new(component.cleansed_html_path)
            # model.save(component_model_path)

            extract_handler.extract_data(component)
            extract_handler.extract_model(component)

            @batch_left -= 1
            break if batch_left.zero?
          end
        end
        # rubocop:enable Metrics/AbcSize

        private

        def guards
          raise "Batch size must be greater than 0, got: #{batch_size}" if batch_size <= 0
          raise 'Extract handler is required' unless extract_handler
          raise 'Extract handler must implement extract_data method' unless extract_handler.respond_to?(:extract_data)
          raise 'Extract handler must implement extract_model method' unless extract_handler.respond_to?(:extract_model)
        end

        def filter_components
          return components unless filter_design_system

          components.select { |component| component.design_system.name == filter_design_system }
        end
      end
    end
  end
end
