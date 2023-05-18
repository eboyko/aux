require 'active_support/inflector'
require 'active_support/dependencies/zeitwerk_integration'
require 'aux/pluggable'
require 'dry/container'
require 'zeitwerk'

# Define some acronym-based inflections using Rails features
ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym('HTTP')
  inflect.acronym('HTML')
end

# Preload dummy classes to emulate a real application
autoloader = Zeitwerk::Loader.new
autoloader.push_dir("#{__dir__}/dummies/pluggable")
autoloader.inflector = ActiveSupport::Dependencies::ZeitwerkIntegration::Inflector
autoloader.setup

# Configure the registry
Aux::Pluggable.registry = Dry::Container.new
