# coding: utf-8
# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'gt06_server/version'

Gem::Specification.new do |spec|
  spec.name    = 'gt06_server'
  spec.version = Gt06Server::VERSION
  spec.authors = ['CoolElvis']
  spec.email   = ['elvisplus2@gmail.com']

  spec.summary                       = 'TODO: Write a short summary, because Rubygems requires one.'
  spec.description                   = 'TODO: Write a longer description or delete this line.'
  spec.homepage                      = "TODO: Put your gem's website or public repo URL here."
  spec.license                       = 'MIT'
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
