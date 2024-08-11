# frozen_string_literal: true

shared_context('with pluggable registry') do
  let(:registry) { Aux::Pluggable.registry }
end
