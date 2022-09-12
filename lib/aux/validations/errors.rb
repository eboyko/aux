# frozen_string_literal: true

require 'aux/validations/error'
require 'aux/validations/errors_presenter'

module Aux
  module Validations
    # Describes a batch of errors that can be initialized using an attribute name or an object that should be validated
    class Errors
      # @overload initialize(subject)
      #   @param base [Object]
      #   @return [self]
      # @overload initialize(attribute, errors)
      #   Use this approach to handle nested errors
      #   @param attribute [Symbol]
      #   @param errors [Aux::Validation::Errors]
      #   @return [self]
      def initialize(base, errors = [])
        @base = base
        @errors = errors
      end

      # @return [Symbol, nil]
      def attribute
        base if base.is_a?(Symbol)
      end

      # @return [Hash]
      def details
        details_presenter.render(self)
      end

      # @return [Hash]
      def group_by_attribute
        errors.group_by { |error| error.attribute }
      end

      # @return [Boolean]
      def nested?
        base.is_a?(Symbol)
      end

      # @return [String, nil]
      def scope
        base.class.name.underscore.gsub('/', '.') unless nested?
      end

      # @overload add(attribute, type, **details)
      #   @param attribute [Symbol]
      #   @param type [Symbol]
      #   @param details [Hash]
      #   @raise [StandardError]
      # @overload add(attribute, errors)
      #   @param attribute [Symbol]
      #   @param errors [Aux::Validations::Errors]
      #   @raise [StandardError]
      def add(attribute, payload, **details)
        case payload
        when Aux::Validations::Errors
          add_nested_error(attribute, payload)
        when Symbol
          add_error(attribute, payload, **details)
        else
          raise StandardError, :unsupported_type
        end
      end

      def clear
        self.errors = []
      end

      # @return [Boolean]
      def empty?
        errors.empty?
      end

      private

      # @!attribute [r] base
      #   @return [Object, Symbol]
      attr_reader :base

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
        errors_factory.new(attribute, type, scope, **details.compact)
      end

      # @param attribute [Symbol] 3
      # @param errors [Aux::Validations::Errors]
      # @return [Aux::Validations::Errors]
      def build_nested_error(attribute, errors)
        self.class.new(attribute, [errors])
      end

      # @return [Class<Aux::Validations::Error>]
      def errors_factory
        Aux::Validations::Error
      end

      # @return [Class<Aux::Validations::ErrorsPresenter>]
      def details_presenter
        Aux::Validations::ErrorsPresenter
      end
    end
  end
end
