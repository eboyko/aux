# frozen_string_literal: true

require 'spec_helper'
require 'dummies/validations/create_parcel_request'

RSpec.describe(CreateParcelRequest) do
  subject(:request) { described_class.new(address: address, weight: weight) }

  let(:address) { '127000, Moscow, 1st Street, 1' }
  let(:weight) { 1.250 }

  describe '#valid?' do
    it { is_expected.to be_valid }

    context 'when address is missing' do
      let(:address) { nil }

      it 'returns false' do
        expect(request).to be_invalid
        expect(request.errors.include?(address: :blank)).to be(true)
      end
    end

    context 'when weight is not greater than zero' do
      let(:weight) { 0 }

      it 'returns false' do
        expect(request).to be_invalid
        expect(request.errors.include?(weight: :greater_than)).to be(true)
      end
    end
  end
end
