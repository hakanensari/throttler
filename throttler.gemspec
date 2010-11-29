# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "throttler/version"

Gem::Specification.new do |s|
  s.name        = "throttler"
  s.version     = "0.2.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hakan Ensari", "Piotr Łaszewski"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://github.com/papercavalier/throttler"
  s.summary     = "A tired, cranky throttler"
  s.description = "A tired, cranky module that throttles parallel-running Ruby scripts on a single machine."

  s.rubyforge_project = "throttler"

  s.add_development_dependency("rspec", ["~> 2.1.0"])

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end

