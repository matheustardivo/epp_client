# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "epp_client/version"

Gem::Specification.new do |s|
  s.name        = "epp_client"
  s.version     = EppClient::VERSION
  s.authors     = ["Matheus Tardivo"]
  s.email       = ["matheustardivo@gmail.com"]
  s.homepage    = "https://github.com/matheustardivo/epp_client"
  s.summary     = %q{Library to access EPP services}
  s.description = s.summary

  s.rubyforge_project = "epp_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake", "~> 0.9"
  s.add_development_dependency "rspec", "~> 2.7"
  s.add_development_dependency "pry", "~> 0.9"
  s.add_development_dependency "awesome_print", "~> 1.0"
  s.add_runtime_dependency "uuid", "~> 2.3"
end
