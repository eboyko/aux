source 'https://rubygems.org'

# Specify dependencies in gemspec file
gemspec

group :test do
  # Load dummy classes
  gem 'zeitwerk', '~> 2.6.16'

  # Use test framework
  gem 'rspec', '~> 3.13.0'

  # Use code analysers and linters
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :documentation do
  gem 'redcarpet', platform: :mri

  # Use annotations and interactive documentation
  gem 'yard', '>= 0.9.36', require: false
end
