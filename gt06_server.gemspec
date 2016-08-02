# coding: utf-8
# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'gt06_server/version'

Gem::Specification.new do |spec|
  spec.name    = 'gt06_server'
  spec.version = Gt06Server::VERSION
  spec.authors = ['CoolElvis']
  spec.email   = ['elvisplus2@gmail.com']

  spec.summary                       = 'TCP server for gt06(TK100) gps tracker'
  spec.description                   = 'TCP server for gt06(TK100) gps tracker'
  spec.homepage                      = 'https://github.com/CoolElvis/gt06_server'
  spec.license                       = 'MIT'

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bindata', '~>2.3'
  spec.add_runtime_dependency 'celluloid-io', '~>0.17.3'
  spec.add_runtime_dependency 'concurrent-ruby', '~>1.0.2'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
