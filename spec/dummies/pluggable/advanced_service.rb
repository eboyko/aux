# frozen_string_literal: true

class AdvancedService
  include Aux::Pluggable

  resolve(:repository, private: false)
  resolve(:settings, private: true)

  # @!attribute [r] user
  #   @return [Object]
  # @!attribute [r] filters
  #   @return [Hash]
  # @!attribute [r] preferences
  #   @return [Hash]
  # @!attribute [r] calculated_variable
  #   @return [Integer]
  attr_reader :user, :filters, :preferences, :calculated_variable

  # @param user [Object]
  # @param filters [Hash]
  def initialize(user, filters:)
    @user = user
    @filters = filters
    @calculated_variable = 42

    # Resolved dependencies are also available during initialization
    @preferences = settings.database_details
  end
end
