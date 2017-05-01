# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in gt06_server.gemspec
gemspec

gem 'rake'

group :test do
  gem 'minitest'
  gem 'codeclimate-test-reporter', require: nil
end

group :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop', require: false
  gem 'reek', require: false
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
end
