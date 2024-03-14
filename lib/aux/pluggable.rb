# frozen_string_literal: true

require 'aux/pluggable/class_methods'
require 'aux/pluggable/connector'
require 'aux/pluggable/dependency'
require 'aux/pluggable/utilities'
require 'aux/registry'

module Aux
  # Describes interface that makes any class able to register itself as well as resolve dependencies
  # rubocop:disable Style/ClassVars
  module Pluggable
    # Extends the including class with ClassMethods and initializes a new Connector instance
    # @param base [Class] the class that includes this module
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        @_pluggable = Connector.new(self, @@registry)
      end
    end

    # @param registry [Dry::Container]
    def self.registry=(registry)
      @@registry = registry
    end

    # @return [Dry::Container]
    def self.registry
      @@registry
    end
  end
  # rubocop:enable Style/ClassVars
end
