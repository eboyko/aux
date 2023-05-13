require 'pluggable_helper'

RSpec.describe(Namespaced::ForeignRegisteredClass) do
  include_context 'with pluggable registry'

  it 'presents in the registry within the root namespace' do
    expect(registry.resolve(:foreign_registered_class)).to be(described_class)
  end
end
