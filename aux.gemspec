require_relative 'lib/aux/version'

Gem::Specification.new do |specification|
  specification.name = 'aux'
  specification.version = Aux::VERSION
  specification.summary = 'Supplementary tools for more effective development'

  specification.authors = ['Evgeny Boyko']
  specification.email = ['eboyko@eboyko.ru']

  specification.add_dependency 'activemodel', '~> 6.1.6'
  specification.add_dependency 'activesupport', '~> 6.1.6'

  specification.required_ruby_version = '>= 2.7.1'
  specification.metadata['rubygems_mfa_required'] = 'true'

  specification.license = 'MIT'
end
