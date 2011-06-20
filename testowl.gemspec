# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "testowl/version"

Gem::Specification.new do |s|
  s.name        = "testowl"
  s.version     = Testowl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill Horsman"]
  s.email       = ["bill@logicalcobwebs.com"]
  s.homepage    = "https://github.com/billhorsman/testowl"
  s.summary     = %q{TestUnit/RSpec, Watchr and Growl Integration for Continuous Testing}
  s.description = %q{TestUnit/RSpec, Watchr and Growl Integration for Continuous Testing}

  s.add_runtime_dependency "watchr"
  s.add_runtime_dependency "rails"
  
  s.files       = [
    "Gemfile",
    "README.markdown",
    "Rakefile",
    "bin/testowl",
    "images/error.png",
    "images/failed.png",
    "images/success.png",
    "images/wait.png",
    "lib/testowl.rb",
    "lib/testowl/growl.rb",
    "lib/testowl/monitor.rb",
    "lib/testowl/rspec_runner.rb",
    "lib/testowl/test_unit_runner.rb",
    "lib/testowl/version.rb",
    "testowl.gemspec"
  ]
  s.executables   = ["testowl"]
  s.require_paths = ["lib"]
end
