# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes the dependency and its preferences
    class Dependency
      # @!attribute [r] target
      #   @return [Object]
      # @!attribute [r] pointer
      #   @return [Symbol, String]
      # @!attribute [r] private
      #   @return [Boolean]
      attr_reader :pointer, :target, :private

      # @param target [Object]
      # @param initialization_block [Proc, nil]
      # @param pointer [Symbol, String]
      # @param private [Boolean]
      def initialize(target, initialization_block = nil, pointer:, private:)
        @target = initialization_block ? initialization_block.call(target) : target
        @pointer = pointer
        @private = private
      end
    end
  end
end
