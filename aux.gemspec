require_relative 'lib/aux/version'

Gem::Specification.new do |specification|
  specification.name = 'aux'
  specification.version = Aux::VERSION
  specification.summary = 'Supplementary tools for more effective development'
  specification.files = ['README.md']

  specification.authors = ['Evgeny Boyko']
  specification.email = ['eboyko@eboyko.ru']
  specification.homepage = 'https://github.com/eboyko/aux'

  specification.add_dependency 'activemodel', '~> 6.1.6'
  specification.add_dependency 'activesupport', '~> 6.1.6'

  specification.add_development_dependency 'rubocop', '~> 1.36.0'

  specification.required_ruby_version = '>= 2.7.1'
  specification.metadata['rubygems_mfa_required'] = 'true'

  specification.license = 'MIT'
end
