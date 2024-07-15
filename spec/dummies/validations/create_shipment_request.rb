require 'aux/validations'
require 'dummies/validations/create_parcel_request'

class CreateShipmentRequest
  include Aux::Validations

  # @!attribute [r] parcels
  #   @return [Array<CreateParcelRequest>]
  attr_reader :parcels

  validate :parcels_presence_and_acceptance

  # @param parcels [Array<Hash>] parcels batch data
  def initialize(parcels:)
    @parcels = parcels.map do |parcel|
      CreateParcelRequest.new(**parcel)
    end
  end

  private

  def parcels_presence_and_acceptance
    return errors.add(:parcels, :empty) unless parcels.any?

    parcels.each do |parcel|
      errors.add(:parcels, parcel.errors) unless parcel.valid?
    end
  end
end
