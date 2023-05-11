# frozen_string_literal: true

module Namespaced
  class ForeignRegisteredClass
    include Aux::Pluggable

    register(initialize: false, memoize: false, scope: nil)
  end
end
