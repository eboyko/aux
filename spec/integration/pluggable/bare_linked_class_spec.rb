# frozen_string_literal: true

require 'pluggable_helper'

RSpec.describe(BareLinkedClass) do
  include_context 'with pluggable registry'

  it 'includes the connector' do
    expect(described_class.instance_variable_get(:@_pluggable)).to be_truthy
    expect(registry.key?(:bare_linked_class)).to be(false)
  end
end
