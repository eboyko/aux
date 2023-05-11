require 'pluggable_helper'

RSpec.describe(RegisteredClass) do
  include_context 'with pluggable registry'

  it 'presents in the registry' do
    expect(registry.resolve(:registered_class)).to be(RegisteredClass)
  end
end
