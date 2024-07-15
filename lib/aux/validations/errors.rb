# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'aux/validations/error'
require 'aux/validations/error_tree_presenter'

module Aux
  module Validations
    # Provides methods to handle an element payload
    class Errors
      # @!attribute [r] attribute
      #   @return [Symbol]
      # @!attribute [r] scope
      #   @return [String]
      attr_reader :attribute, :scope

      # @overload initialize(base)
      #   @param base [Object]
      # @overload initialize(base, errors)
      #   @param base [Symbol] attribute name
      #   @param errors [Errors, nil] previous errors if any
      def initialize(base, errors = nil)
        if base.is_a?(Symbol)
          @attribute = base
          @scope = errors&.scope
          @collection = errors.nil? ? [] : [errors]
        else
          @attribute = nil
          @scope = base.class.name.underscore.tr('/', '.')
          @collection = []
        end
      end

      # @overload add(attribute, type, **details)
      #   @param attribute [Symbol]
      #   @param type [Symbol, nil]
      #   @param details [Hash, nil]
      # @overload add(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Error, Errors, Array<Error, Errors>]
      def add(attribute, type = :invalid, **details)
        case type
        when Symbol
          @collection.push(Error.new(attribute, @scope, type, **details))
        when Errors
          @collection.push(Errors.new(attribute, type))
        when Array
          type.each { |payload| add(attribute, payload) }
        else
          raise(ArgumentError, "Unsupported argument given (#{type.class})")
        end
      end

      def clear
        @collection = []
      end

      # @return [Boolean]
      def empty?
        @collection.empty?
      end

      # @overload include?(*attributes)
      #   @param attributes [Array<Symbol>]
      #   @return [TrueClass, FalseClass]
      #
      # @overload include?(**criteria)
      #   @param criteria [Hash<Symbol, Symbol>]
      #   @return [TrueClass, FalseClass]
      def include?(*attributes, **criteria)
        if attributes.any?
          include_attributes?(*attributes)
        elsif criteria.any?
          include_criteria_match?(**criteria)
        end
      end

      # @return [Array<Error, Errors>]
      def all
        @collection
      end

      # @return [Hash{Symbol => Array<Error, Errors>}]
      def group_by_attribute
        @collection.group_by(&:attribute)
      end

      # @param block [Proc]
      # @return [Array]
      def map(&block)
        @collection.map(&block)
      end

      # @return [Hash]
      def tree
        ErrorTreePresenter.render(self)
      end

      private

      # @param attributes [Array<Hash>]
      # @return [TrueClass, FalseClass]
      def include_attributes?(*attributes)
        match_count = @collection.count do |element|
          return false unless attributes.include?(element.attribute)

          true
        end

        match_count == attributes.count
      end

      # @param criteria [Hash<Symbol, Symbol>]
      # @return [TrueClass, FalseClass]
      def include_criteria_match?(**criteria)
        attributes, types = criteria.to_a.transpose

        match_count = @collection.count do |element|
          return false unless attributes.include?(element.attribute) && types.include?(element.type)

          true
        end

        match_count == criteria.count
      end
    end
  end
end
