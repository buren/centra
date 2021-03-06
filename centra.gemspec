# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "centra/version"

Gem::Specification.new do |spec|
  spec.name          = "centra"
  spec.version       = Centra::VERSION
  spec.authors       = ["Jacob Burenstam"]
  spec.email         = ["burenstam@gmail.com"]

  spec.summary       = "Dealing with Centra stuff."
  spec.description   = "Dealing with Centra stuff, i.e reading export files, generating summaries, matching orders with Rule orders."
  spec.homepage      = "https://github.com/buren/centra"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "honey_format", "~> 0.14", ">= 0.14.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pg", "~> 1.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
end
