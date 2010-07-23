require "rubygems"
require "bundler"
Bundler.require(:default)

require "rspec/core/rake_task"

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "throttler"
  gemspec.summary = "Throttles the frequency at which concurrently-running instances of a Ruby block are executed."
  gemspec.description = "Throttles the frequency at which concurrently-running instances of a Ruby block are executed."
  gemspec.files = Dir.glob("lib/**/*") + %w{LICENSE README.rdoc}
  gemspec.require_path = "lib"
  gemspec.email = "code@papercavalier.com"
  gemspec.homepage = "http://github.com/papercavalier/throttler"
  gemspec.authors = ["Hakan Ensari"]
end

Jeweler::GemcutterTasks.new
