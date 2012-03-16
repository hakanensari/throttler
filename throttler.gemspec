# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'throttler/version'

Gem::Specification.new do |s|
  s.name        = 'throttler'
  s.version     = Throttler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Hakan Ensari', 'Piotr Łaszewski']
  s.email       = ['hakan.ensari@papercavalier.com']
  s.homepage    = 'https://github.com/hakanensari/throttler'
  s.summary     = 'Rate-limits code execution'
  s.description = 'Throttler rate-limits code execution across threads or processes.'

  s.add_development_dependency 'rake', '~> 0.9.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end

