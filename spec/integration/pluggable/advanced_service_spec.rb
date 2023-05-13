require 'pluggable_helper'

RSpec.describe(AdvancedService) do
  include_context 'with pluggable registry'

  subject(:service) do
    described_class.new(
      user,
      filters: filters
    )
  end

  let(:user) { double(:user) }
  let(:filters) { double(:filters) }

  it 'returns successfully initialized instance' do
    expect(service.user).to be(user)
    expect(service.filters).to be(filters)
    expect(service.repository).to be(registry.resolve(:repository))
    expect(service.preferences).to be(registry.resolve(:settings).database_details)
    expect(service.calculated_variable).to be(42)
  end
end
