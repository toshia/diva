# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'diva/version'

Gem::Specification.new do |spec|
  spec.name          = "diva"
  spec.version       = Diva::VERSION
  spec.authors       = ["Toshiaki Asai"]
  spec.email         = ["toshi.alternative@gmail.com"]

  spec.summary       = %q{Implementation of expression for handling things.}
  spec.homepage      = "https://github.com/toshia/diva"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", '>= 1.16.1', '< 2.2'
  spec.add_development_dependency "rake", '>= 13.0.1', '< 14.0'
  spec.add_development_dependency "minitest", '>= 5.13.0', '< 5.14'
  spec.add_development_dependency "pry", '>= 0.12.2', '< 1.0'
  spec.add_development_dependency "simplecov", '>= 0.17.1', '< 1.0'

  spec.add_dependency "addressable", ">= 2.5.2", "< 2.8"
end
