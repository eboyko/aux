# frozen_string_literal: true

module Aux
  module Validations
    # Describes a single validation error
    class Error
      # @!attribute [r] attribute
      #   @return [Symbol]
      # @!attribute [r] scope
      #   @return [String]
      # @!attribute [r] type
      #   @return [Symbol]
      # @!attribute [r] details
      #   @return [Hash]
      attr_reader :attribute, :scope, :type, :details

      # @param attribute [Symbol]
      # @param scope [String]
      # @param type [Symbol]
      # @param details [Hash]
      def initialize(attribute, scope, type, **details)
        @attribute = attribute
        @scope = scope
        @type = type
        @details = details
      end
    end
  end
end
