source 'https://rubygems.org'
git_source(:github) { |repository| "https://github.com/#{repository}.git" }

# Specify dependencies in gemspec file
gemspec

group :test do
  gem 'rspec', '~> 3.12'
end

group :documentation do
  gem 'redcarpet', platform: :mri
  gem 'yard'
  gem 'yard-junk'
end
