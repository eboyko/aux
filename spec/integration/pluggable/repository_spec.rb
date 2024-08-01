# frozen_string_literal: true

require 'pluggable_helper'

RSpec.describe(Repository) do
  subject(:repository) { registry.resolve(:repository) }

  include_context 'with pluggable registry'

  let(:settings) { registry.resolve(:settings) }

  it 'has publicly available isolated scope of the settings' do
    expect(repository.settings).to be(settings.database_details)
  end
end
