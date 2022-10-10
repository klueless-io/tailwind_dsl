# frozen_string_literal: true

module TailwindDsl
  module Transformers
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
          @files = files
        end

        def add_file(file)
          files << file

          file
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
      end
    end
  end
end
