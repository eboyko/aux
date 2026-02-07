# frozen_string_literal: true

# Data-driven finite state machine with a built-in event log.
#
# Unlike traditional FSM libraries that hardcode transitions in a DSL,
# Ledger stores the transition graph in the database, making it
# configurable per process at runtime. Every state change produces
# an immutable event record with user and payload, providing
# a complete audit trail by default.
module Ledger; end
