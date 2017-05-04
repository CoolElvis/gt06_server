# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in gt06_server.gemspec
gemspec

gem 'rake'

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'minitest'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'pry'
  gem 'pry-byebug'
  gem 'reek', require: false
  gem 'rubocop', require: false
end
