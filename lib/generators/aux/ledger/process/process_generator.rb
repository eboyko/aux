# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Aux
  module Ledger
    class ProcessGenerator < Rails::Generators::NamedBase
      include ActiveRecord::Generators::Migration

      desc 'Creates a process and its event models'

      class_option(:origin, type: :string, required: true, desc: 'The origin model class for the process events')

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
      def event_class_name
        "#{class_name}Event"
      end

      # @return [String]
      def event_table_name
        "#{table_name.singularize}_events"
      end

      # @return [Class]
      def origin_class_name
        options[:origin].constantize
      end

      # @return [String]
      def origin_name
        options[:origin].demodulize.underscore
      end

      # @return [String]
      def origin_table_name
        origin_class_name.table_name
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
