# frozen_string_literal: true

module Aux
  module Validations
    # Creates a structured tree of errors that can be used to generate localized error messages.
    # Handles error objects and nested error collections, organizing them by attributes and scopes
    # to create a hierarchical representation.
    class ErrorTreePresenter
      class << self
        # @param errors [Errors]
        # @return [Hash]
        def render(errors)
          {
            scope: errors.scope,
            errors: render_root_errors(errors)
          }
        end

        private

        # @param errors [Errors]
        # @return [Array<Hash>]
        def render_root_errors(errors)
          errors.group_by_attribute.map do |attribute, collection|
            {
              attribute: attribute,
              errors: render_attribute_errors(collection)
            }
          end
        end

        # @param collection [Array<Error, Errors>]
        # @raise [ArgumentError]
        # @return [Array<Hash>]
        def render_attribute_errors(collection)
          collection.map do |element|
            case element
            when Error
              render_error(element)
            when Errors
              render_nested_errors(element)
            else
              raise(ArgumentError, "Unexpected error type: #{element.class}")
            end
          end
        end

        # @param errors [Errors]
        # @return [Hash]
        def render_nested_errors(errors)
          {
            scope: errors.scope,
            errors: render_scope_errors(errors)
          }
        end

        # @param errors [Errors]
        # @return [Array<Hash>]
        def render_scope_errors(errors)
          errors.group_by_attribute.flat_map do |_attribute, collection|
            render_scope_attributes(collection)
          end
        end

        # @param collection [Array<Error, Errors>]
        # @return [Array<Hash>]
        def render_scope_attributes(collection)
          collection.flat_map do |element|
            element.group_by_attribute.map do |attribute, nested_collection|
              {
                attribute: attribute,
                errors: render_scope_attribute_errors(nested_collection)
              }
            end
          end
        end

        # @param collection [Array<Error, Errors>]
        # @raise [ArgumentError]
        # @return [Array<Hash>]
        def render_scope_attribute_errors(collection)
          collection.map do |element|
            case element
            when Error
              render_error(element)
            when Errors
              render_scope_errors(element)
            else
              raise(ArgumentError, "Unexpected error type: #{element.class}")
            end
          end
        end

        # @param error [Error]
        # @return [Hash]
        def render_error(error)
          {
            type: error.type,
            details: error.details
          }
        end
      end
    end
  end
end
