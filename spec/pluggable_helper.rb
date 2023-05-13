require 'aux/pluggable'
require 'dry/container'
require 'zeitwerk'

# Preload dummy classes to emulate a real application
autoloader = Zeitwerk::Loader.new
autoloader.push_dir("#{__dir__}/dummies/pluggable")
autoloader.setup

# Configure the registry
Aux::Pluggable.registry = Dry::Container.new
