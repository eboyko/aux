# frozen_string_literal: true

module Aux
  module Validations
    # Describes a collection of errors that can be initialized with an attribute name or an object to be validated
    class Errors
      # @!attribute [r] scope
      #   @return [String, nil]
      # @!attribute [r] attribute
      #   @return [Symbol, nil]
      attr_reader :scope, :attribute

      # @overload initialize(subject)
      #   @param subject [Object]
      # @overload initialize(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Errors]
      def initialize(subject, errors = [])
        @scope = subject.is_a?(Symbol) ? nil : subject.class.name.underscore.tr('/', '.')
        @attribute = subject.is_a?(Symbol) ? subject : nil
        @errors = errors
      end

      # @overload add(attribute, type, **details)
      #   @param attribute [Symbol]
      #   @param type [Symbol]
      #   @param details [Hash]
      #   @raise [StandardError]
      # @overload add(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Array<Errors, Error>]
      #   @raise [StandardError]
      # @overload add(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Errors]
      #   @raise [StandardError]
      def add(attribute, subject, **details)
        case subject
        when Symbol
          add_error(attribute, subject, **details)
        when Array
          add_nested_error(attribute, subject)
        when Errors
          add_nested_error(attribute, [subject])
        else
          raise(ArgumentError, "Unsupported argument given (#{subject.class})")
        end
      end

      def clear
        self.errors = []
      end

      # @return [Boolean]
      def empty?
        errors.empty?
      end

      # @param block [Proc]
      def map(&block)
        errors.map(&block)
      end

      # @return [Hash<Symbol, Array>]
      def group_by_attribute
        errors.group_by(&:attribute)
      end

      private

      # @!attribute [rw] errors
      #   @return [Array<Error, Errors>]
      attr_accessor :errors

      # @param attribute [Symbol]
      # @param type [Symbol]
      # @param details [Hash]
      def add_error(attribute, type, **details)
        errors.push(build_error(attribute, type, **details))
      end

      # @param attribute [Symbol]
      # @param nested_errors [Errors]
      def add_nested_error(attribute, nested_errors)
        errors.push(build_nested_error(attribute, nested_errors))
      end

      # @param attribute [Symbol]
      # @param type [Symbol]
      # @param details [Hash]
      # @return [Error]
      def build_error(attribute, type, **details)
        factory.new(attribute, scope, type, **details)
      end

      # @param attribute [Symbol] 3
      # @param errors [Errors]
      # @return [Errors]
      def build_nested_error(attribute, errors)
        self.class.new(attribute, errors)
      end

      # @return [Class<Error>]
      def factory
        Error
      end
    end
  end
end
