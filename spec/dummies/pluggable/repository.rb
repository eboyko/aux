# frozen_string_literal: true

class Repository
  include Aux::Pluggable

  register(initialize: true, memoize: true)
  resolve(:settings, -> (settings) { settings.database_details }, private: false)
end
