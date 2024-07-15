require 'aux/validations'
class CreateParcelRequest
  include Aux::Validations

  # @!attribute [r] address
  #   @return [String]
  # @!attribute [r] weight
  #   @return [Float]
  attr_reader :address, :weight

  validates :address, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }

  # @param address [String]
  # @param weight [Float]
  def initialize(address:, weight:)
    @address = address
    @weight = weight
  end
end
