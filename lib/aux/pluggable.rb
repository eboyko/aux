# frozen_string_literal: true

require 'aux/pluggable/class_methods'
require 'aux/pluggable/registration'

module Aux
  # Describes interface that makes any class able to register itself as well as resolve dependencies
  module Pluggable
    # @param base [Class]
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        @_registry = @@registry
        @_dependencies = {}
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
end
