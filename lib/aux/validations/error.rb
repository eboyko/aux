# frozen_string_literal: true

module Aux
  module Validations
    # Describes a single validation error
    class Error
      # @!attribute [r] attribute
      #   @return [Symbol]
      # @!attribute [r] type
      #   @return [Symbol]
      # @!attribute [r] scope
      #   @return [String]
      # @!attribute [r] details
      #   @return [Hash]
      attr_reader :attribute, :type, :scope, :details

      # @param attribute [Symbol]
      # @param type [Symbol]
      # @param scope [String]
      # @param details [Hash]
      def initialize(attribute, type, scope, **details)
        @attribute = attribute
        @type = type
        @scope = scope
        @details = details
      end
    end
  end
end
