# frozen_string_literal: true

require 'aux/utilities'

module Aux
  module Pluggable
    # Describes methods that would be inherited by pluggable classes
    module ClassMethods
      # @param dependencies [Hash]
      # @return [self]
      # rubocop:disable Metrics/MethodLength
      def new(**dependencies)
        instance = allocate

        # Configure dependencies that come from registry
        @_dependencies.each do |name, cipher|
          instance.instance_variable_set("@#{name}", -> { @_registry.resolve(cipher) })
          class_eval { define_method(name) { instance_variable_get("@#{name}").call } }
          private name
        end

        # Configure dependencies that come from custom initialization procedure
        dependencies.each do |name, dependency|
          instance.instance_variable_set("@#{name}", dependency)
          class_eval { define_method(name) { instance_variable_get("@#{name}") } }
          private name
        end

        instance
      end
      # rubocop:enable Metrics/MethodLength

      # @param cipher [Symbol, String]
      # @param initialize [Boolean]
      # @param memoize [Boolean]
      def register(cipher = nil, initialize: false, memoize: false)
        @_registry.register(cipher || Aux::Utilities.underscore(name), memoize: memoize) { initialize ? new : self }
      end

      # @param cipher [Symbol, String]
      # @param as [Symbol, String]
      def resolve(cipher, as: nil, scope: :local)
        namespace = scope == :local ? Aux::Utilities.underscore(name).split('.')[0..-2].join('.') : nil
        @_dependencies[as || cipher] = [namespace, cipher].compact.join('.')
      end
    end
  end
end
