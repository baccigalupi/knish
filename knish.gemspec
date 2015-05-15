# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knish/version'

Gem::Specification.new do |spec|
  spec.name          = "knish"
  spec.version       = Knish::VERSION
  spec.authors       = ["Kane Baccigalupi"]
  spec.email         = ["baccigalupi@gmail.com"]
  spec.summary       = %q{File backed data models, excellent for CMS apps!}
  spec.description   = %q{The problem with CMSs is that you really want your application content in source control,
  not a database. Knish provides a structured data model for saving data to json, and formatted html to markdown}
  spec.homepage      = "http://github.com/baccigalupi/knish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
