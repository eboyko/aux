# frozen_string_literal: true

# Preload shared contexts and examples
Dir["#{__dir__}/support/**/*.rb"].sort.each { |file| require(file) }

RSpec.configure do |config|
  # When no filter given, search and run focused tests
  config.filter_run_when_matching :focus

  # Disables rspec monkey patches (no reason for their existence tbh)
  config.disable_monkey_patching!

  # Run ruby in verbose mode
  config.warnings = true

  # Collect all failing expectations automatically,
  # without calling aggregate_failures everywhere
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
