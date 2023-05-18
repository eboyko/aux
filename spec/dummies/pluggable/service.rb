# frozen_string_literal: true

class Service
  include Aux::Pluggable

  register(initialize: true, memoize: true)
  resolve(:repository, private: false)
  resolve(:html_parser, scope: :http)
  resolve(:settings, private: true)
end
