# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mmfcc/version"

Gem::Specification.new do |s|
  s.name        = "mmfcc"
  s.version     = Mmfcc::VERSION
  s.authors     = ["RittaNarita"]
  s.email       = ["narittan@gmail.com"]
  s.homepage    = "https://github.com/RittaNarita/Mmfcc"
  s.summary     = %q{the tool for making mfcc of songs}
  s.description = %q{you can make the Mel-frequency cepstrum, which is a feature spectrum of a song. }
  s.license       = "GPLv2"
  s.rubyforge_project = "mmfcc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "ai4r", '~> 0'
end
