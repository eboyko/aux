# frozen_string_literal: true

class Service
  include Aux::Pluggable

  register(initialize: true, memoize: true)
  resolve(:repository, private: false)
  resolve(:settings, private: true)
end
