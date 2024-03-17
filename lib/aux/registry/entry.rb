# frozen_string_literal: true

module Aux
  class Registry
    # Describes a registered dependency
    # @!visibility private
    class Entry
      # @param constructor [Proc]
      # @param memoization_required [TrueClass, FalseClass]
      def initialize(constructor, memoization_required)
        @constructor = constructor
        @memoization_required = memoization_required

        @mutex = Thread::Mutex.new
      end

      # @return [Object]
      def call
        return @constructor.call unless @memoization_required

        @call ||= @mutex.synchronize do
          @constructor.call
        end
      end
    end
  end
end
