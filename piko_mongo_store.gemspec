# frozen_string_literal: true

begin
  require "./lib/piko_mongo_store/version"
rescue LoadError
  module PikoMongoStore; VERSION = "0"; end
end

Gem::Specification.new do |spec|
  spec.name          = "piko_mongo_store"
  spec.version       = PikoMongoStore::VERSION
  spec.authors       = ["Szymon Kopciewski"]
  spec.email         = ["s.kopciewski@gmail.com"]
  spec.summary       = "Abstraction layer for storage"
  spec.description   = "Abstraction layer for storage"
  spec.homepage      = "https://github.com/skopciewski/piko_mongo_store"
  spec.license       = "GPL-3.0"

  spec.require_paths = ["lib"]
  spec.files         = Dir.glob("{bin,lib}/**/*") + \
                       %w[Gemfile LICENSE README.md CHANGELOG.md]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.add_runtime_dependency "logger2r", "~>1"
  spec.add_runtime_dependency "mongo", "~>2.4"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"
end
