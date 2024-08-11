require_relative 'lib/aux/version'

Gem::Specification.new do |specification|
  specification.name = 'aux'
  specification.version = Aux::VERSION
  specification.summary = 'Supplementary tools for more effective development'
  specification.files = Dir['MIT-LICENSE', 'README.md', 'aux.gemspec', 'lib/**/*']

  specification.authors = ['Evgeny Boyko']
  specification.email = ['eboyko@eboyko.ru']
  specification.homepage = 'https://github.com/eboyko/aux'

  specification.add_dependency 'concurrent-ruby', '~> 1.2', '>= 1.2.3'
  specification.add_dependency 'activemodel', '>= 6.1', '< 8'

  specification.required_ruby_version = '>= 2.7.1'
  specification.metadata['rubygems_mfa_required'] = 'true'

  specification.license = 'MIT'
end
