# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kekeewin/version'

Gem::Specification.new do |gem|
  gem.name          = "kekeewin"
  gem.version       = Kekeewin::VERSION
  gem.authors       = ["Christopher Jones"]
  gem.email         = ["crjones@gmail.com"]
  gem.description   = "API wrapper for Kekeewin on Scouting.io."
  gem.summary       = "API wrapper for Kekeewin on Scouting.io."
  gem.homepage      = "http://scouting.io"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_runtime_dependency "oauth2"
  gem.add_runtime_dependency "httparty"
end
