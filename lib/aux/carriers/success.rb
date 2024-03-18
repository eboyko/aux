# frozen_string_literal: true

module Aux
  module Carriers
    class Success
      # @!attribute [r] code
      #   @return [Symbol]
      # @!attribute [r] payload
      #   @return [Object, nil]
      attr_reader :code, :payload

      # @param code [Symbol]
      # @param payload [Object, nil]
      def initialize(code, payload = nil)
        @code = code
        @payload = payload
      end

      # @return [TrueClass]
      def succeeded?
        true
      end

      # @!method successful?
      #   @return [TrueClass]
      alias successful? succeeded?

      # @!method success?
      #   @return [TrueClass]
      alias success? succeeded?

      # @return [FalseClass]
      def failed?
        false
      end

      # @!method failure?
      #   @return [FalseClass]
      alias failure? failed?
    end
  end
end
