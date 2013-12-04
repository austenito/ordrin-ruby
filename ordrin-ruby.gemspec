# -*- encoding: utf-8 -*-

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'ordrin_ruby'
  gem.version       = OrdrIn::VERSION
  gem.authors       = ['Austen Ito']
  gem.email         = ['austen.dev@gmail.com']
  gem.homepage      = 'https://github.com/austenito/ordrin_ruby'
  gem.summary       = 'Consuming the Ordr.in API'
  gem.description   = gem.summary
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']
  gem.license = 'MIT'

  gem.add_dependency 'activesupport', ">= 3.2.13"
  gem.add_dependency 'hashie'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'faraday'

  gem.add_development_dependency 'bourne', "1.5.0"
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'mocha', "~> 0.14.0"
  gem.add_development_dependency 'pry-debugger'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'yard'
end
