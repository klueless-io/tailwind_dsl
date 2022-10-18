# frozen_string_literal: true

module TailwindDsl
  module Etl
    module ComponentModels
      # Extract component models by reading the cleansed component HTML and then using GPT3 to infer both the data/model structure.
      class Extractor
        attr_reader :uikit
        attr_reader :target_root_path
        attr_reader :batch_size
        attr_reader :use_prompt

        def initialize(uikit, target_root_path, batch_size: 1, use_prompt: false, filter_design_system: nil)
          @uikit = uikit
          @target_root_path = target_root_path
          @batch_size = batch_size
          @batch_left = batch_size
          @use_prompt = use_prompt
        end

        # Goal:       Extract the next (batch_size) component models using GPT3 and save them to target_root_path
        #             Create a data file at: design_system.name -> group-hierarchy -> component-name.data.json
        #             Create a model file at: design_system.name -> group-hierarchy -> component-name.model.rb

        # Process:    Collect all components and optionally filter them by design system name.
        #             Look for the next component to be processed, if it does not exist in the target folder then process it.
        #             decrement the batch_left counter and continue until batch_left is 0.
        #             if :use_prompt is true then display the input/output files and ask if you wish to process the component or skip.
        #             process the component by calling the GPT3 API and save the results to the target folder.

        def extract
        end

        # def components
        #   @components ||= uikit.design_systems.map do |design_system|
        #     design_system.components.map do |component|
        #       Component.new(design_system, component, source_root_path, target_root_path)
        #     end
        #   end.flatten
        # end
      end
    end
  end
end
