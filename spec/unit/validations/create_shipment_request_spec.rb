# frozen_string_literal: true

require 'dummies/validations/create_shipment_request'

RSpec.describe(CreateShipmentRequest) do
  subject(:request) { described_class.new(parcels: parcels) }

  describe '#valid?' do
    subject(:call) { request.valid? }

    let(:parcels) { [{ address: '127000, Moscow, 1st Street, 1', weight: 1.25 }] }

    it { is_expected.to be(true) }

    context 'when parcel data invalid' do
      let(:parcels) { [{ address: nil, weight: 0 }, { address: nil, weight: 0 }] }

      it 'returns false' do
        expect(call).to be(false)
      end
    end
  end
end
