# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Group
      #
      # Group represents a collection of Tailwind CSS components withing a named group or category
      class Group < TailwindDsl::Etl::Element
        attr_accessor :key
        attr_accessor :type
        attr_accessor :folder
        attr_accessor :sub_keys
        attr_accessor :files

        def initialize(**args)
          @key  = grab_arg(args, :key, guard: 'Missing key')
          @type = grab_arg(args, :type, guard: 'Missing type')
          @folder = grab_arg(args, :folder, guard: 'Missing folder')
          @sub_keys = grab_arg(args, :sub_keys, guard: 'Missing sub_keys')

          @files = grab_arg(args, :files, default: []).map { |file| convert_file(file) }.compact
        end

        def add_file(file)
          add = convert_file(file)

          return nil if add.nil?

          files << add

          add
        end

        def to_h
          {
            key: key,
            type: type,
            folder: folder,
            sub_keys: sub_keys,
            files: files.map(&:to_h)
          }
        end

        private

        def convert_file(file)
          return nil if file.nil?

          return file if file.is_a?(SourceFile)
          return SourceFile.new(**file) if file.is_a?(Hash)

          puts "Unknown file type: #{file.class}"
          nil
        end
      end
    end
  end
end
