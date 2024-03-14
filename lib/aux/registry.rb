# frozen_string_literal: true

require 'aux/registry/entry'
require 'concurrent/map'

module Aux
  # Registry for dependency injection
  class Registry
    def initialize
      @prototypes = ::Concurrent::Map.new
    end

    # @param key [Symbol, String]
    # @param memoize [TrueClass, FalseClass, NilClass]
    # @param constructor [Proc]
    def register(key, memoize: false, &constructor)
      @prototypes.put(key.to_s, Entry.new(constructor, memoize))
    end

    # @param key [Symbol, String]
    def resolve(key)
      @prototypes.fetch(key.to_s).call
    end

    # @param key [Symbol, String]
    # @return [TrueClass, FalseClass]
    def key?(key)
      @prototypes.key?(key.to_s)
    end
  end
end
