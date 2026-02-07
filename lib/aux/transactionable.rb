# frozen_string_literal: true

# Provides a set of methods for safe execution within database transactions,
# including support for nested transactions and advisory locking
#
module Aux
  module Transactionable
    # @param options [Hash]
    # @yield
    def transaction(**options)
      ActiveRecord::Base.transaction(**options) { yield }
    end
  end
end
