require 'spec_helper'
require 'aux/carriers/success'

RSpec.describe(Aux::Carriers::Success) do
  describe '.new' do
    subject(:success) { described_class.new(:created) }

    it 'responds to predicate methods' do
      expect(success).to be_succeeded
      expect(success).to be_successful
      expect(success).to be_success
    end

    it 'responds to negated predicate methods' do
      expect(success).not_to be_failed
      expect(success).not_to be_failure
    end

    it 'has code and empty payload' do
      expect(success).to have_attributes(code: :created, payload: nil)
    end

    context 'when both code and payload given' do
      subject(:success) { described_class.new(:created, payload) }

      let(:payload) { { id: 1 } }

      it 'has code and payload' do
        expect(success).to have_attributes(code: :created, payload: payload)
      end
    end
  end
end
