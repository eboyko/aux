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
    @@registry = Aux::Registry.new

    # Extends the including class with ClassMethods and initializes a new Connector instance
    # @param base [Class] the class that includes this module
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        @_pluggable = Connector.new(self, @@registry)
      end
    end

    # @yield configure the module
    # @yieldparam pluggable [Module<Aux::Pluggable>]
    # @yieldparam registry [Aux::Registry]
    def self.configure
      yield(self, @@registry) if block_given?
    end

    # @param registry [Aux::Registry]
    def self.registry=(registry)
      @@registry = registry
    end

    # @return [Aux::Registry]
    def self.registry
      @@registry
    end
  end
  # rubocop:enable Style/ClassVars
end
