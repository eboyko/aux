# frozen_string_literal: true

class RegisteredInstance
  include Aux::Pluggable

  register(initialize: true, memoize: false)
end
