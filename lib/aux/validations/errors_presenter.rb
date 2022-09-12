# frozen_string_literal: true

module Aux
  module Validations
    class ErrorsPresenter
      class << self
        # @param errors [Array<Aux::Validations::Errors, Aux::Validations::Error>, Aux::Validations::Errors, Aux::Validations::Error]
        # @return [Hash]
        def render(errors)
          if errors.is_a?(Array)
            render_batch(errors)
          elsif errors.is_a?(Aux::Validations::Errors)
            render_collection(errors)
          elsif errors.is_a?(Aux::Validations::Error)
            render_element(errors)
          end
        end

        private

        # @param batch [Array<Aux::Validations::Errors>, Array<Aux::Validations::Error>]
        # @return [Array<Aux::Validations::Errors>, Array<Aux::Validations::Error>, Array<Hash>]
        def render_batch(batch)
          batch.map { |error| render(error) }.flatten
        end

        # @param collection [Aux::Validations::Errors]
        # @return [Array, Hash]
        def render_collection(collection)
          collection.nested? ? render_nested_collection(collection) : render_root_collection(collection)
        end

        # @param nested_collection [Aux::Validations::Errors]
        # @return [Array]
        def render_nested_collection(nested_collection)
          nested_collection.group_by_attribute.map { |_attribute, errors| render(errors) }
        end

        # @param root_collection [Aux::Validations::Errors]
        # @return [Hash]
        def render_root_collection(root_collection)
          root_collection.group_by_attribute.map do |attribute, errors|
            [attribute, render(errors.one? ? errors.first : errors)]
          end.to_h
        end

        # @param error [Aux::Validations::Error]
        # @return [Hash]
        def render_element(error)
          {
            type: error.type,
            scope: error.scope,
            details: error.details
          }
        end
      end
    end
  end
end
