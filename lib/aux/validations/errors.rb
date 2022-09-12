# frozen_string_literal: true

require 'aux/validations/error'
require 'aux/validations/errors_tree_presenter'

module Aux
  module Validations
    # Describes a batch of errors that can be initialized using an attribute name or an object that should be validated
    class Errors
      # @!attribute [r] scope
      #   @return [String, nil]
      # @!attribute [r] attribute
      #   @return [Symbol, nil]
      attr_reader :scope, :attribute

      # @overload initialize(subject)
      #   @param base [Object]
      #   @return [self]
      # @overload initialize(attribute, errors)
      #   Use this approach to handle nested errors
      #   @param attribute [Symbol]
      #   @param errors [Aux::Validation::Errors]
      #   @return [self]
      def initialize(base, errors = [])
        @scope = base.is_a?(Symbol) ? nil : base.class.name.underscore.tr('/', '.')
        @attribute = base.is_a?(Symbol) ? base : nil
        @errors = errors
      end

      # @overload add(attribute, type, **details)
      #   @param attribute [Symbol]
      #   @param type [Symbol]
      #   @param details [Hash]
      #   @raise [StandardError]
      # @overload add(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Array<Aux::Validations::Errors, Aux::Validations::Error>]
      #   @raise [StandardError]
      # @overload add(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Aux::Validations::Errors]
      #   @raise [StandardError]
      def add(attribute, payload, **details)
        case payload
        when Symbol
          add_error(attribute, payload, **details)
        when Array
          add_nested_error(attribute, payload)
        when Aux::Validations::Errors
          add_nested_error(attribute, [payload])
        else
          raise StandardError, :unsupported_type
        end
      end

      # @return [Hash]
      def tree
        tree_presenter.render(self)
      end

      # @return [Hash]
      def group_by_attribute
        errors.group_by(&:attribute)
      end

      def clear
        self.errors = []
      end

      # @return [Boolean]
      def empty?
        errors.empty?
      end

      private

      # @!attribute [rw] errors
      #   @return [Array<Aux::Validations::Errors, Aux::Validations::Error>]
      attr_accessor :errors

      # @param attribute [Symbol]
      # @param type [Symbol]
      # @param details [Hash]
      def add_error(attribute, type, **details)
        errors.push(build_error(attribute, type, **details))
      end

      # @param attribute [Symbol]
      # @param nested_errors [Aux::Validations::Errors]
      def add_nested_error(attribute, nested_errors)
        errors.push(build_nested_error(attribute, nested_errors))
      end

      # @param attribute [Symbol]
      # @param type [Symbol]
      # @param details [Hash]
      # @return [Aux::Validations::Error]
      def build_error(attribute, type, **details)
        errors_factory.new(attribute, type, scope, **details)
      end

      # @param attribute [Symbol] 3
      # @param errors [Aux::Validations::Errors]
      # @return [Aux::Validations::Errors]
      def build_nested_error(attribute, errors)
        self.class.new(attribute, errors)
      end

      # @return [Class<Aux::Validations::ErrorsTreePresenter>]
      def tree_presenter
        Aux::Validations::ErrorsTreePresenter
      end

      # @return [Class<Aux::Validations::Error>]
      def errors_factory
        Aux::Validations::Error
      end
    end
  end
end
