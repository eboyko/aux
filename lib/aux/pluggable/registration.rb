# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes a wrapper for registry data
    class Registration
      # @!attribute [r] name
      #   @return [Symbol, String]
      # @!attribute [r] initialization_required
      #   @return [TrueClass, FalseClass]
      # @!attribute [r] memoization_required
      #   @return [TrueClass, FalseClass]
      attr_reader :name, :initialization_required, :memoization_required

      # @param name [Symbol, String]
      # @param initialization_required [TrueClass, FalseClass]
      # @param memoization_required [TrueClass, FalseClass]
      def initialize(name, initialization_required, memoization_required)
        @name = name
        @initialization_required = initialization_required
        @memoization_required = memoization_required
      end
    end
  end
end
