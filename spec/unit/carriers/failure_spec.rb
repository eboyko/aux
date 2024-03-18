require 'spec_helper'
require 'aux/carriers/failure'

RSpec.describe(Aux::Carriers::Failure) do
  describe '.new' do
    subject(:failure) { described_class.new(:code) }

    it 'responds to predicate methods' do
      expect(failure).to be_failed
      expect(failure).to be_failure
    end

    it 'responds to negated predicate methods' do
      expect(failure).not_to be_succeeded
      expect(failure).not_to be_successful
      expect(failure).not_to be_success
    end

    it 'has code and empty details and payload' do
      expect(failure).to have_attributes(code: :code, details: nil, payload: nil)
    end

    context 'when details given' do
      subject(:failure) { described_class.new(:conflict, details) }

      let(:details) { { status: :missing } }

      it 'has code and details' do
        expect(failure).to have_attributes(code: :conflict, details: details, payload: nil)
      end

      context 'when payload given' do
        subject(:failure) { described_class.new(:code, details, payload) }

        let(:payload) { { id: 1 } }

        it 'has code, details and payload' do
          expect(failure).to have_attributes(code: :code, details: details, payload: payload)
        end
      end
    end
  end
end
