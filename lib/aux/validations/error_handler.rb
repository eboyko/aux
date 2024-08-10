# frozen_string_literal: true

module Aux
  module Validations
    # Describes methods that represent validation errors in simple structures pretty enough for the API response.
    module ErrorHandler
      private

      DEFAULT_ERROR_SCOPE_PREFIX = 'errors'
      GENERIC_ERROR_SCOPE = 'errors.generic'

      # @overload format_errors(error_batch, scope)
      #   @param error_batch [Array]
      #   @param scope [Symbol, String, nil]
      #   @raise [ArgumentError]
      #   @return [Array<Hash>]
      # @overload format_errors(error_collection, scope)
      #   @param error_collection [Errors]
      #   @param scope [Symbol, String, nil]
      #   @raise [ArgumentError]
      #   @return [Array<Hash>]
      # @overload format_errors(error, scope)
      #   @param scope [Symbol, String, nil]
      #   @param error [Error]
      #   @raise [ArgumentError]
      #   @return [Hash]
      def format_errors(payload, scope = nil)
        case payload
        when Array
          format_error_batch(payload, scope)
        when Errors
          format_error_collection(payload, scope)
        when Error
          format_error(payload, scope)
        else
          raise ArgumentError
        end
      end

      # @param batch [Array<Error, Errors>]
      # @param scope [Symbol, String, nil]
      # @return [Array<Hash>]
      def format_error_batch(batch, scope = nil)
        batch.flat_map { |element| format_errors(element, scope) }
      end

      # @param collection [Errors]
      # @param scope [Symbol, String, nil]
      def format_error_collection(collection, scope = nil)
        return format_primary_error_collection(collection, scope || collection.scope) unless collection.attribute

        format_secondary_error_collection(collection, "#{scope}.#{collection.attribute}")
      end

      # @param collection [Errors]
      # @param scope [Symbol, String, nil]
      # @return [Array<Hash>]
      def format_primary_error_collection(collection, scope = nil)
        collection.group_by_attribute.map do |attribute, entities|
          {
            kind: entities.all?(Error) ? 'collection' : 'batch',
            attribute: attribute,
            errors: format_errors(entities, scope)
          }
        end
      end

      # @param collection [Errors]
      # @param scope [Symbol, String, nil]
      # @return [Array<Hash>]
      def format_secondary_error_collection(collection, scope = nil)
        collection.group_by_attribute.flat_map do |_attribute, items|
          format_errors(items.one? ? items.first : items, scope)
        end
      end

      # @param error [Error]
      # @param scope [Symbol, String, nil]
      # @return [Hash]
      def format_error(error, scope = nil)
        {
          type: error.type,
          details: error.details,
          message: format_message(error, scope)
        }
      end

      # @param error [Error]
      # @param scope [Symbol, String, nil]
      # @return [String]
      def format_message(error, scope = nil)
        scope ? format_secondary_message(error, scope) : format_primary_message(error)
      end

      # @param error [Error]
      # @return [String]
      def format_primary_message(error)
        I18n.translate(
          error.type,
          scope: "#{self.class::DEFAULT_ERROR_SCOPE_PREFIX}.#{error.scope}.#{error.attribute}",
          default: format_fallback_message(error),
          **error.details
        )
      end

      # @param error [Error]
      # @param scope [Symbol, String, nil]
      # @return [String]
      def format_secondary_message(error, scope)
        I18n.translate(
          error.type,
          scope: "#{self.class::DEFAULT_ERROR_SCOPE_PREFIX}.#{scope}.#{error.attribute}",
          default: format_primary_message(error),
          **error.details
        )
      end

      # @param error [Error]
      # @return [String]
      def format_fallback_message(error)
        I18n.translate(error.type, scope: self.class::GENERIC_ERROR_SCOPE, default: error.type)
      end
    end
  end
end
