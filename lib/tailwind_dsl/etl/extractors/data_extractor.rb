# frozen_string_literal: true

module TailwindDsl
  module Etl
    module Extractors
      # Extract component data an place into a new file using a GTP3 extraction.
      class DataExtractor < TailwindDsl::Etl::Extractors::BaseExtractor
        attr_accessor :component

        def target_file
          component.absolute.target_data_file
        end

        # rubocop:disable Metrics/AbcSize
        def extract
          builder = Gpt3::Builder::Gpt3Builder.init

          tokens = 250

          source_file = component.absolute.target_clean_html_file
          source = File.read(source_file)

          target_file = component.absolute.target_data_file
          component_type = component.group.sub_keys.last

          builder
            .start("Extract JSON data from '#{component_type}' HTML component")
            .message('HTML:')
            .example(source)
            .message('JSON:')
            .complete(engine: 'code-davinci-002', max_tokens: tokens, suffix: "\n")
            .write_result(target_file)

          puts "Extracted data for #{component_type} component: #{component.name} into file"
          puts target_file
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
