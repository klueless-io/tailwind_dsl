# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Source File
      #
      # SourceFile represents a list of source files that contain raw Tailwind CSS components
      class SourceFile < TailwindDsl::Etl::Element
        attr_accessor :name
        attr_accessor :file_name
        attr_accessor :file_name_only
        attr_accessor :file
        attr_accessor :target

        def initialize(**args)
          @name = grab_arg(args, :name, guard: 'Missing name')
          @file_name = grab_arg(args, :file_name, guard: 'Missing file_name')
          @file_name_only = grab_arg(args, :file_name_only, guard: 'Missing file_name_only')
          @file = grab_arg(args, :file, guard: 'Missing file')
          @target = convert_target(grab_arg(args, :target))
        end

        def to_h
          result = {
            name: name,
            file_name: file_name,
            file_name_only: file_name_only,
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
            TargetFile.new(**target)
          else
            raise "Unknown target type: #{target.class}"
          end
        end
      end
    end
  end
end
