# frozen_string_literal: true

module Aux
  # Random methods for internal usage
  module Utilities
    # @param class_name [String]
    # @return [String]
    def self.underscore(class_name)
      class_name.dup.gsub(/::/, '.').gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
  end
end
