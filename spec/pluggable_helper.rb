# frozen_string_literal: true

require 'active_support/inflector'
require 'aux/pluggable'
require 'zeitwerk'

# Define some acronym-based inflections using Rails features
ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym('HTTP')
  inflect.acronym('HTML')
end

# Preload dummy classes to emulate a real application
autoloader = Zeitwerk::Loader.new
autoloader.push_dir("#{__dir__}/dummies/pluggable")
autoloader.inflector = ActiveSupport::Inflector
autoloader.setup
