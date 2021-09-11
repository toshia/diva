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
  spec.required_ruby_version = '>= 2.6.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", '>= 1.16.1', '< 3.0'
  spec.add_development_dependency "rake", '>= 13.0.1', '< 14.0'
  spec.add_development_dependency "minitest", '>= 5.14.4', '< 5.15'
  spec.add_development_dependency "irb", '>= 1.3.7', '< 2.0'
  spec.add_development_dependency "simplecov", '>= 0.17.1', '< 1.0'
  spec.add_development_dependency "rubocop", '>= 1.20.0', '< 1.21.0'
  spec.add_dependency "addressable", ">= 2.5.2", "< 3.0"
end
