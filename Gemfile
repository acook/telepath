source 'https://rubygems.org'

# Specify your gem's dependencies in telepath.gemspec
gemspec

# test coverage
gem 'coveralls', require: false

# don't include these on CI
unless ENV['CI'] then
  # debugging
  gem 'pry'
  gem 'pry-theme'

  # metrics
  gem 'metric_fu'
end
