# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes methods that would be inherited by pluggable classes
    module ClassMethods
      # @param dependencies [Hash{Symbol => Object}]
      def new(**dependencies)
        instance = allocate

        # Configure dependencies that come from the registry
        @_dependencies.each do |name, dependency|
          instance.instance_variable_set("@#{name}", dependency)
        end

        # Configure dependencies that come from the customized initialization procedure
        dependencies.each do |name, dependency|
          instance.instance_variable_set("@#{name}", dependency) if @_dependencies.include?(name)
        end

        # Run the rest of customized initialization procedure
        instance.send(:initialize, **dependencies)

        instance
      end

      private

      # @param initialize [TrueClass, FalseClass]
      # @param memoize [TrueClass, FalseClass]
      # @param scope [TrueClass, Symbol, String, nil]
      # @param as [Symbol, String, nil]
      def register(initialize: false, memoize: false, scope: true, as: nil)
        dependency_cipher = Utilities.dependency_cipher(name, scope: scope, code: as)
        @_registry.register(dependency_cipher, memoize: memoize) { initialize ? new : self }
      end

      # @param code [Symbol, String]
      # @param initialization_block [Proc, nil]
      # @param scope [TrueClass, Symbol, String, nil]
      # @param as [Symbol, String]
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def resolve(code, initialization_block = nil, scope: true, as: nil)
        dependency_cipher = Utilities.dependency_cipher(name, scope: scope, code: code)
        dependency_alias = as || code

        # The process of preloading classes is a bit messy. Therefore, why we wrap the dependency in a Proc.
        # This allows us not to worry about the absence of the referenced class in the registry during assembly.
        # Using an initialization block can be convenient in some cases, for example, to resolve some
        # of the global settings without accessing the whole thing.
        @_dependencies[dependency_alias] =
          if initialization_block
            -> { initialization_block.call(@_registry.resolve(dependency_cipher)) }
          else
            -> { @_registry.resolve(dependency_cipher) }
          end

        # The final step is to declare instance variables and methods to access them.
        instance_eval do
          define_method(dependency_alias) do
            if instance_variable_get("@#{dependency_alias}").is_a?(Proc)
              instance_variable_get("@#{dependency_alias}").call
            else
              instance_variable_get("@#{dependency_alias}")
            end
          end

          private dependency_alias
        end

        singleton_class.class_eval do
          define_method(dependency_alias) { @_dependencies[dependency_alias].call }
          private dependency_alias
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    end
  end
end
