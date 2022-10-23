# frozen_string_literal: true

module TailwindDsl
  module Etl
    module Extractors
      # Extract component data an place into a new file using a an extractor.
      #
      # Currently designed to work with GPT3 to infer some type of target structure.
      class BaseExtractor
        attr_accessor :component

        def target_file
          raise NotImplementedError, 'target_file is not implemented'
        end

        def extract
          raise NotImplementedError, 'extract is not implemented'
        end
      end
    end
  end
end
