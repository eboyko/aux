# frozen_string_literal: true

module Aux
  module Carriers
    # Describes a service failure
    class Failure
      # @!attribute [r] code
      #   @return [Symbol]
      # @!attribute [r] details
      #   @return [Object, nil]
      # @!attribute [r] payload
      #   @return [Object, nil]
      attr_reader :code, :details, :payload

      # @param code [Symbol]
      # @param details [Object, nil]
      # @param payload [Object, nil]
      def initialize(code, details = nil, payload = nil)
        @code = code
        @details = details
        @payload = payload
      end

      # @return [FalseClass]
      def succeeded?
        false
      end

      # @!method successful?
      #   @return [FalseClass]
      alias successful? succeeded?

      # @!method success?
      #   @return [FalseClass]
      alias success? succeeded?

      # @return [TrueClass]
      def failed?
        true
      end

      # @!method failure?
      #   @return [TrueClass]
      alias failure? failed?
    end
  end
end
