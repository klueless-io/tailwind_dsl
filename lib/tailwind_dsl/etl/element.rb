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

      # Map data to a class
      #
      # @param klass [Class] The class to map to
      # @param data [Hash, Class] The data to map can be hash, an instance of the class or nil
      def map_to(klass, data)
        return nil if data.nil?

        return data if data.is_a?(klass)
        return klass.new(**data) if data.is_a?(Hash)

        puts "Data of type: #{data.class} cannot be converted to #{klass}"
        nil
      end

      # Add data onto an array
      #
      # @param target_list [Array] The array to add to
      # @param data [Hash, Class] The data to add can be hash or an instance of the class. Nil data will not be added
      def add_to_list(klass, target_list, data)
        item = map_to(klass, data)

        return nil if item.nil?

        target_list << item

        item
      end
    end
  end
end
