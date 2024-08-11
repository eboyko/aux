# frozen_string_literal: true

class Settings
  include Aux::Pluggable

  register(initialize: false, memoize: false)

  def self.database_details
    @database_details ||= { address: '127.0.0.1' }
  end
end
