# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Aux
  module Ledger
    class PrimitivesGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      desc 'Creates Ledger primitives and schema migration'

      source_root(File.expand_path('templates', __dir__))

      def create_migration
        migration_template('create_ledger_primitives.rb.erb', 'db/migrate/create_ledger_primitives.rb')
      end

      def create_models
        template('module.rb.erb', 'app/models/ledger.rb')
        template('process.rb.erb', 'app/models/ledger/process.rb')
        template('state.rb.erb', 'app/models/ledger/state.rb')
        template('transition.rb.erb', 'app/models/ledger/transition.rb')
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::STRING.to_f}]"
      end
    end
  end
end
