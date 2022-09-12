# frozen_string_literal: true

module Aux
  module Validations
    # Describes tree structure presentation scenario of errors
    class ErrorsTreePresenter
      class << self
        # @return [Array, Hash, Aux::Validations::Error]
        def render(payload)
          case payload
          when Array
            process_array(payload)
          when Aux::Validations::Errors
            render_collection(payload)
          when Aux::Validations::Error
            payload
          end
        end

        private

        # @param errors [Array]
        # @return [Array]
        def process_array(errors)
          errors.map { |item| render(item) }.flatten
        end

        # @param errors [Aux::Validations::Errors]
        # @return [Array, Hash]
        def render_collection(errors)
          errors.attribute ? process_attribute_errors(errors) : process_errors(errors)
        end

        # @param errors [Aux::Validations::Errors]
        # @return [Hash]
        def process_errors(errors)
          errors.group_by_attribute.transform_values do |items|
            render(items.one? ? items.first : items)
          end
        end

        # @param errors [Aux::Validations::Errors]
        # @return [Array]
        def process_attribute_errors(errors)
          errors.group_by_attribute.map { |_attribute, items| render(items) }.flatten
        end
      end
    end
  end
end
