# frozen_string_literal: true

class RegisteredClass
  include Aux::Pluggable

  register(initialize: false, memoize: false)
end
