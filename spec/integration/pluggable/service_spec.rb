require 'pluggable_helper'

RSpec.describe(Service) do
  context 'when dependencies are overridden during initialization' do
    subject(:service) do
      described_class.new(
        repository: repository,
        settings: settings
      )
    end

    let(:repository) { double(:repository) }
    let(:settings) { double(:settings) }

    it 'returns successfully initialized instance' do
      expect(service.repository).to be(repository)

      expect(service).not_to respond_to(:settings)
      expect(service.instance_variable_get(:@settings)).to be(settings)
    end
  end
end
