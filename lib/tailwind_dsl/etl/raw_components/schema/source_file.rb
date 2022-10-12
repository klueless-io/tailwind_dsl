# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Source File
      #
      # SourceFile represents a list of source files that contain raw Tailwind CSS components
      class SourceFile
        attr_accessor :name
        attr_accessor :file_name
        attr_accessor :file_name_only
        attr_accessor :absolute_file
        attr_accessor :file
        attr_accessor :target

        # rubocop:disable Metrics/ParameterLists
        def initialize(name:, file_name:, file_name_only:, absolute_file:, file:, target: nil)
          @name = name
          @file_name = file_name
          @file_name_only = file_name_only
          @absolute_file = absolute_file
          @file = file
          @target = convert_target(target)
        end
        # rubocop:enable Metrics/ParameterLists

        def to_h
          result = {
            name: name,
            file_name: file_name,
            file_name_only: file_name_only,
            absolute_file: absolute_file,
            file: file
          }
          result[:target] = target.to_h if target
          result
        end

        private

        def convert_target(target)
          return nil if target.nil?

          case target
          when TargetFile
            target
          when Hash
            TargetFile.new(target)
          else
            raise "Unknown target type: #{target.class}"
          end
        end
      end
    end
  end
end
