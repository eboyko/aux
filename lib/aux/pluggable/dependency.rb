# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes the dependency and its preferences
    class Dependency
      # @!attribute [r] pointer
      #   @return [Symbol, String]
      # @!attribute [r] private
      #   @return [Boolean]
      attr_reader :pointer, :private

      # @param target [Proc]
      # @param pointer [Symbol, String]
      # @param private [Boolean]
      def initialize(target:, pointer:, private:)
        @target = target
        @pointer = pointer
        @private = private
      end

      # @return [Object]
      def target
        @target.call
      end
    end
  end
end
