require 'pluggable_helper'

RSpec.describe(Repository) do
  include_context 'with pluggable registry'

  subject(:repository) { registry.resolve(:repository) }

  let(:settings) { registry.resolve(:settings) }

  it 'has publicly available isolated scope of the settings' do
    expect(repository.settings).to be(settings.database_details)
  end
end
