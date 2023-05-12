# frozen_string_literal: true

module Aux
  module Pluggable
    # Random methods for internal usage
    module Utilities
      # First, we need to determine the appropriate namespace (also called the scope) in which to resolve something.
      # By default, we assume that the developers want to resolve a dependency from the same namespace as the
      # referencing class. Another approach is to allow developers to set the correct scope themselves.
      #
      # @param subject [ClassName]
      # @param scope [TrueClass, Symbol, String, nil]
      # @param code [TrueClass, Symbol, String, nil]
      # @return [String]
      def self.dependency_cipher(subject, scope: nil, code: nil)
        native_cipher = dependency_native_cipher(subject)
        native_cipher_partitions = native_cipher.rpartition('.')
        scope = scope == true ? native_cipher_partitions.first : scope
        code = code.nil? ? native_cipher_partitions.last : code

        [scope, code].reject { |part| part.nil? || part.empty? }.join('.')
      end

      # @param subject [ClassName]
      # @return [String]
      def self.dependency_native_cipher(subject)
        subject.dup.gsub(/::/, '.').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      end
    end
  end
end
