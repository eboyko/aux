# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes the dependency and its preferences
    # @!visibility private
    class Dependency
      # @!attribute [r] target
      #   @return [Object]
      # @!attribute [r] pointer
      #   @return [Symbol, String]
      # @!attribute [r] private
      #   @return [Boolean]
      attr_reader :target, :pointer, :private

      # @param target [Object]
      # @param pointer [Symbol, String]
      # @param private [Boolean]
      # @param initialization_block [Proc, nil]
      def initialize(target, pointer, private, initialization_block = nil)
        @target = initialization_block&.call(target) || target
        @pointer = pointer
        @private = private
      end
    end
  end
end
