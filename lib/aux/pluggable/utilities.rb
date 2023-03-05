# frozen_string_literal: true

module Aux
  module Pluggable
    # Random methods for internal usage
    module Utilities
      # First, we need to determine the appropriate namespace (also called the scope) in which to resolve something.
      # By default, we assume that the developers want to resolve a dependency from the same namespace as the
      # referencing class. Another approach is to allow developers to set the correct scope themselves.
      #
      # @param class_name [Class]
      # @param scope [TrueClass, Symbol, String, nil]
      # @param code [TrueClass, Symbol, String, nil]
      # @return [String]
      def self.dependency_cipher(class_name, scope: nil, code: nil)
        native_cipher = dependency_native_cipher(class_name)
        native_cipher_partitions = native_cipher.rpartition('.')
        scope = scope.is_a?(TrueClass) ? native_cipher_partitions.first : scope
        code = code.nil? ? native_cipher_partitions.last : code

        [scope, code].reject { |part| part.nil? || part.empty? }.join('.')
      end

      # @param class_name [Class]
      # @return [String]
      def self.dependency_native_cipher(class_name)
        class_name.dup.gsub(/::/, '.').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      end
    end
  end
end
