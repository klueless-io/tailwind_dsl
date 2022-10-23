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

        def extract
          puts 'do some magic and write to target_file'
          puts "target_file: #{target_file}"
          File.write(target_file, 'GTP3 data')
          # do some GPT3 magic
        end
      end
    end
  end
end
