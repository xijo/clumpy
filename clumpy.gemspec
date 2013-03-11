# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clumpy/version'

Gem::Specification.new do |spec|
  spec.name          = "clumpy"
  spec.version       = Clumpy::VERSION
  spec.authors       = ["Johannes Opper"]
  spec.email         = ["xijo@gmx.de"]
  spec.description   = %q{Cluster points e.g. for a map}
  spec.summary       = %q{Cluster a bunch of points}
  spec.homepage      = "http://github.com/xijo/clumpy"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
