# frozen_string_literal: true

require 'pluggable_helper'

RSpec.describe(RegisteredInstance) do
  include_context 'with pluggable registry'

  let(:first_call) { registry.resolve(:registered_instance) }
  let(:second_call) { registry.resolve(:registered_instance) }

  it 'returns a new instance on every call' do
    expect(first_call).not_to be(second_call)
  end
end
