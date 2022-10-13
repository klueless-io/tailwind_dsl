# frozen_string_literal: true

module TailwindDsl
  module Etl
    # Base class for all ETL data objects that load/persist JSON data
    class Element
      # Get the value of an argument from a hash
      #
      # @param args [Hash] The hash of arguments
      # @param key [String, Symbol] The key to look up
      # @param guard [String] The error message to raise if the key is not found. Guards are optional.
      # @param default [Object] The default value to return if the key is not found. Also optional, defaults to nil.
      def grab_arg(args, key, guard: nil, default: nil)
        value = args[key.to_sym] || args[key.to_s]

        raise guard if value.nil? && guard

        value || default
      end
    end
  end
end
