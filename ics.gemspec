# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ics/version"

Gem::Specification.new do |s|
  s.name        = "ics"
  s.version     = ICS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jared Ning']
  s.email       = ['jared@redningja.com']
  s.summary     = 'Read .ics files'
  s.description = 'Parse exported .ics files into Event objects.'

  s.rubyforge_project = "ics"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'autotest'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rspec', '2.12'
end
