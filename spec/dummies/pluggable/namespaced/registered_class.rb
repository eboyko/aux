# frozen_string_literal: true

module Namespaced
  class RegisteredClass
    include Aux::Pluggable

    register(initialize: false, memoize: false)
  end
end
