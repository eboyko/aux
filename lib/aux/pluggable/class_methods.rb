# frozen_string_literal: true

module Aux
  module Pluggable
    # Describes methods that would be inherited by pluggable classes
    module ClassMethods
      # Create a new instance of the class that includes the Pluggable module
      # @param positional_arguments [Array<Object>]
      # @param keyword_arguments [Hash{Symbol => Object}]
      # @return [Object]
      #
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def new(*positional_arguments, **keyword_arguments)
        instance = allocate

        # Configure some local variables for shorter calls
        # @type [Aux::Pluggable::Connector]
        pluggable = instance.class.instance_variable_get(:@_pluggable)
        dependencies_keys = pluggable.dependencies.map(&:pointer)

        # Configure dependencies that come from the registry
        pluggable.dependencies.each do |dependency|
          instance.instance_variable_set("@#{dependency.pointer}", dependency.target)

          # The next lines are required to make resolved dependencies available
          # by its reader methods within customized initialization
          #
          # TODO: Discuss whether this is appropriate behaviour
          next if instance.respond_to?(dependency.pointer, true)

          define_method(dependency.pointer) { instance_variable_get("@#{dependency.pointer}") }
          next unless dependency.private

          private(dependency.pointer)
        end

        # Configure dependencies that come from the customized initialization procedure
        dependencies_overrides = keyword_arguments.slice(*dependencies_keys)
        dependencies_overrides.each do |pointer, target|
          instance.instance_variable_set("@#{pointer}", target)
        end

        # Run the origin's initialization procedure if any other arguments given
        additional_keyword_arguments = keyword_arguments.reject { |key, _value| dependencies_keys.include?(key) }

        # TODO: Consider checks like positional_arguments.any? or additional_keyword_arguments.any?
        instance.send(:initialize, *positional_arguments, **additional_keyword_arguments)

        instance
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      # @param initialize [TrueClass, FalseClass]
      # @param memoize [TrueClass, FalseClass]
      # @param scope [Symbol, String, TrueClass, nil]
      # @param as [Symbol, String, nil]
      def register(initialize: false, memoize: false, scope: true, as: nil)
        @_pluggable.register(initialize, memoize, scope, as)
      end

      # @param code [Symbol, String]
      # @param initialization_block [Proc, nil]
      # @param scope [TrueClass, Symbol, String, nil]
      # @param private [TrueClass, FalseClass]
      # @param as [Symbol, String, nil]
      def resolve(code, initialization_block = nil, scope: true, private: true, as: nil)
        @_pluggable.resolve(code, scope, private, as, initialization_block)
      end
    end
  end
end
