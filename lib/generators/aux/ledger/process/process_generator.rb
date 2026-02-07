# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Aux
  module Ledger
    class ProcessGenerator < Rails::Generators::NamedBase
      include ActiveRecord::Generators::Migration

      desc 'Creates a process and its event models'

      source_root(File.expand_path('templates', __dir__))

      def create_migration_file
        migration_template('migration.rb.erb', "db/migrate/create_#{table_name}.rb")
      end

      def create_model_files
        template('process.rb.erb', "app/models/#{file_path}.rb")
        template('event.rb.erb', "app/models/#{file_path}_event.rb")
      end

      private

      # @return [Array<String>]
      def process_namespace
        class_name.deconstantize.presence
      end

      # @return [String]
      def process_name
        class_name.demodulize.singularize.underscore
      end

      # @return [String]
      def process_table_name
        table_name
      end

      # @return [String]
      def event_table_name
        "#{table_name.singularize}_events"
      end

      # @return [String]
      def migration_class_name
        "Create#{class_name.gsub('::', '').pluralize}"
      end

      # @return [String]
      def migration_version
        "[#{ActiveRecord::VERSION::STRING.to_f}]"
      end
    end
  end
end
