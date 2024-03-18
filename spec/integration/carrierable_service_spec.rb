require 'spec_helper'
require 'dummies/carrierable_service'

RSpec.describe(CarrierableService) do
  subject(:service) { described_class.new }

  describe '#general_success' do
    subject(:result) { service.general_success }

    it 'returns a success carrier with default code' do
      expect(result).to be_a(Aux::Carriers::Success)
      expect(result.code).to eq(:ok)
    end
  end

  describe '#success_with_code' do
    subject(:result) { service.success_with_code(:created) }

    it 'returns a success carrier with specified code' do
      expect(result).to be_a(Aux::Carriers::Success)
      expect(result.code).to eq(:created)
    end
  end

  describe '#success_with_payload' do
    subject(:result) { service.success_with_payload(payload) }

    let(:payload) { { id: 1 } }

    it 'returns a success carrier with specified details' do
      expect(result).to be_a(Aux::Carriers::Success)
      expect(result.payload).to eq(payload)
    end
  end

  describe '#success_with_code_and_payload' do
    subject(:result) { service.success_with_code_and_payload(:created, payload) }

    let(:payload) { { id: 1 } }

    it 'returns a success carrier with specified code and payload' do
      expect(result).to be_a(Aux::Carriers::Success)
      expect(result.code).to eq(:created)
      expect(result.payload).to eq(payload)
    end
  end

  describe '#general_failure' do
    subject(:result) { service.general_failure }

    it 'returns a failure carrier with default code' do
      expect(result).to be_a(Aux::Carriers::Failure)
      expect(result.code).to eq(:internal_server_error)
    end
  end

  describe '#failure_with_code' do
    subject(:result) { service.failure_with_code(:not_found) }

    it 'returns a failure carrier with specified code' do
      expect(result).to be_a(Aux::Carriers::Failure)
      expect(result.code).to eq(:not_found)
    end
  end

  describe '#failure_with_details' do
    subject(:result) { service.failure_with_details(details) }

    let(:details) { %i[conflict] }

    it 'returns a failure carrier with specified details' do
      expect(result).to be_a(Aux::Carriers::Failure)
      expect(result.code).to eq(:internal_server_error)
      expect(result.details).to eq(details)
    end
  end

  describe '#failure_with_code_and_details' do
    subject(:result) { service.failure_with_code_and_details(:conflict, details) }

    let(:details) { { checksum: :invalid } }

    it 'returns a failure carrier with specified code and details' do
      expect(result).to be_a(Aux::Carriers::Failure)
      expect(result.code).to eq(:conflict)
      expect(result.details).to eq(details)
    end
  end

  describe '#failure_with_code_details_and_payload' do
    subject(:result) { service.failure_with_code_details_and_payload(:conflict, details, payload) }

    let(:details) { { checksum: :invalid } }
    let(:payload) { { expected_checksum: 0 } }

    it 'returns a failure carrier with specified code, details and payload' do
      expect(result).to be_a(Aux::Carriers::Failure)
      expect(result.code).to eq(:conflict)
      expect(result.details).to eq(details)
      expect(result.payload).to eq(payload)
    end
  end
end
