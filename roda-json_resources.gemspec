# coding: utf-8
Gem::Specification.new do |spec|
  spec.name         = 'roda-json_resources'
  spec.version      = '0.2.2'
  spec.authors      = ['Chris Frank']
  spec.email        = ['chris.frank@thefutureproject.org']

  spec.summary      = 'A plugin for Roda to respond to CRUD actions with JSON'
  spec.description  = spec.summary
  spec.homepage     = 'https://github.com/chrisfrank/roda-json_resources'
  spec.license      = 'MIT'

  spec.files        = Dir['lib/**/*']
  spec.require_path = 'lib'

  spec.add_runtime_dependency 'multi_json', '~> 1'
  spec.add_runtime_dependency 'roda', '~> 3'
  spec.add_runtime_dependency 'roar', '~> 1'
  spec.add_runtime_dependency 'rack-reducer', '~> 0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
