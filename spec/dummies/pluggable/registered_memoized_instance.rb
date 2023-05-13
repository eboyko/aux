# frozen_string_literal: true

class RegisteredMemoizedInstance
  include Aux::Pluggable

  register(initialize: true, memoize: true)
end
