# frozen_string_literal: true

module TailwindDsl
  module Etl
    module RawComponents
      # Group
      #
      # Group represents a collection of Tailwind CSS components withing a named group or category
      class Group
        attr_accessor :key
        attr_accessor :type
        attr_accessor :folder
        attr_accessor :sub_keys
        attr_accessor :files

        def initialize(key:, type:, folder:, sub_keys:, files: [])
          @key = key
          @type = type
          @folder = folder
          @sub_keys = sub_keys

          @files = []
          files.each { |file| add_file(file) }
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
          return SourceFile.new(file) if file.is_a?(Hash)

          puts "Unknown file type: #{file.class}"
          nil
        end
      end
    end
  end
end