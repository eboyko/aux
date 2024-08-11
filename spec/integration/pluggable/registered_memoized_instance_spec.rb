# frozen_string_literal: true

require 'pluggable_helper'

RSpec.describe(RegisteredMemoizedInstance) do
  include_context 'with pluggable registry'

  let(:first_call) { registry.resolve(:registered_memoized_instance) }
  let(:second_call) { registry.resolve(:registered_memoized_instance) }

  it 'returns the same instance on every call' do
    expect(first_call).to be(second_call)
  end
end
