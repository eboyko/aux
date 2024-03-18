# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes the bridge between a pluggable class and the registry
    # @!visibility private
    class Connector
      # @!attribute [r] dependencies
      #   @return [Array<Dependency>]
      attr_reader :dependencies

      # @param subject [Class]
      # @param registry [Aux::Registry]
      def initialize(subject, registry)
        @subject = subject
        @registry = registry
        @dependencies = []
      end

      # @param initialization_required [TrueClass, FalseClass] whether the subject requires initialization before use
      # @param memoization_required [TrueClass, FalseClass] whether the subject should be memoized
      # @param namespace [Symbol, String, TrueClass, nil] the namespace to register the subject
      # @param code [Symbol, String, nil] an alternate name
      def register(initialization_required, memoization_required, namespace, code)
        configure(initialization_required, memoization_required, namespace, code)

        # Register the subject in the registry using the provided options
        @registry.register(@cipher, memoize: @memoization_required) do
          @initialization_required ? @subject.new : @subject
        end
      end

      # @param code [Symbol, String] the name of the dependency
      # @param namespace [Symbol, String, TrueClass, nil] whether to resolve the dependency in the same namespace
      # @param private [TrueClass, FalseClass] whether to make the dependency private
      # @param as [Symbol, String, nil] an internal alias name for the dependency
      # @param initialization_block [Proc, nil] an optional block used to initialize the dependency
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def resolve(code, namespace, private, as, initialization_block = nil)
        cipher = Utilities.dependency_cipher(@subject.name, namespace, code)
        load_class(cipher)

        dependency = Dependency.new(@registry.resolve(cipher), as || code, private, initialization_block)
        @dependencies.push(dependency)

        if @initialization_required
          @subject.class_eval do
            define_method(dependency.pointer) { instance_variable_get("@#{dependency.pointer}") }
            private(dependency.pointer) if dependency.private
          end
        else
          @subject.instance_variable_set("@#{dependency.pointer}", dependency.target)
          @subject.singleton_class.class_eval do
            define_method(dependency.pointer) { instance_variable_get("@#{dependency.pointer}") }
            private(dependency.pointer) if dependency.private
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      private

      # @param initialization_required [TrueClass, FalseClass]
      # @param memoization_required [TrueClass, FalseClass]
      # @param namespace [TrueClass, Symbol, String, nil]
      # @param code [Symbol, String, nil]
      def configure(initialization_required, memoization_required, namespace, code)
        @cipher = Utilities.dependency_cipher(@subject.name, namespace, code)
        @initialization_required = initialization_required
        @memoization_required = memoization_required
        @namespace = namespace
        @code = code
      end

      # Loads a class specified by the given cipher string. If any of the classes in the cipher string
      # have not yet been loaded, this method will automatically load them as needed
      #
      # @param cipher [String] the string that represents the fully-qualified name of the class
      # @return [Class] the loaded class
      def load_class(cipher)
        cipher.split('.').reduce(Object) do |namespace, class_name|
          if defined?(ActiveSupport::Inflector)
            namespace.const_get(class_name.camelcase)
          else
            namespace.const_get(class_name.split('_').map(&:capitalize).join)
          end
        end
      end
    end
  end
end
