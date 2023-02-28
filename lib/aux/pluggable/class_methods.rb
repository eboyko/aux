# frozen_string_literal: true

require 'aux/utilities'

module Aux
  module Pluggable
    # Describes methods that would be inherited by pluggable classes
    module ClassMethods
      # @param dependencies [Hash{Symbol => Object}]
      # @return [self]
      def new(**dependencies)
        instance = allocate

        # Configure dependencies that come from the registry
        @_dependencies.each do |name, dependency|
          instance.instance_variable_set("@#{name}", dependency)
        end

        # Configure dependencies that come from the customized initialization procedure
        dependencies.each do |name, dependency|
          instance.instance_variable_set("@#{name}", dependency)
        end

        instance
      end

      private

      # @param initialize [TrueClass, FalseClass]
      # @param memoize [TrueClass, FalseClass]
      # @param as [Symbol, String, nil]
      def register(initialize: false, memoize: false, as: nil)
        @_registration = Registration.new(as || Aux::Utilities.underscore(name), initialize, memoize)

        @_registry.register(@_registration.name, memoize: @_registration.memoization_required) do
          @_registration.initialization_required ? new : self
        end
      end

      # @param code [Symbol, String]
      # @param initialization_block [Proc, nil]
      # @param scope [TrueClass, Symbol, String]
      # @param as [Symbol, String]
      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      def resolve(code, initialization_block = nil, scope: true, as: nil)
        # First, we need to determine the appropriate namespace (also called the scope) in which to resolve something.
        # By default, we assume that the developers want to resolve a dependency from the same namespace as the
        # referencing class. Another approach is to allow developers to set the correct scope themselves.
        scope =
          case scope
          when TrueClass
            Aux::Utilities.underscore(name).rpartition('.').first
          when Symbol, String
            scope
          end

        # The process of preloading classes is a bit messy. Therefore, why we wrap the dependency in a Proc.
        # This allows us not to worry about the absence of the referenced class in the registry during assembly.
        # Using an initialization block can be convenient in some cases, for example, to resolve some
        # of the global settings without accessing the whole thing.
        dependency_cipher = [scope, code].reject { |part| part.nil? || part.empty? }.join('.')
        dependency =
          if initialization_block
            -> { initialization_block.call(@_registry.resolve(dependency_cipher)) }
          else
            -> { @_registry.resolve(dependency_cipher) }
          end

        # The final step is to declare instance variables and methods to access them.
        dependency_alias = as || code

        if defined?(@_registration) && @_registration&.initialization_required
          @_dependencies[dependency_alias] = dependency
        end

        instance_eval do
          define_method(dependency_alias) do
            if instance_variable_get("@#{dependency_alias}").is_a?(Proc)
              instance_variable_set("@#{dependency_alias}", instance_variable_get("@#{dependency_alias}").call)
            else
              instance_variable_get("@#{dependency_alias}")
            end
          end

          private dependency_alias
        end

        singleton_class.class_eval do
          define_method(dependency_alias) { dependency.call }
          private dependency_alias
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    end
  end
end
