# -*- coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name         = "tree_support"
  s.version      = "0.0.1"
  s.author       = "akicho8"
  s.email        = "akicho8@gmail.com"
  s.homepage     = "https://github.com/akicho8/tree_support"
  s.summary      = "tree support library"
  s.description  = "tree support library"
  s.platform     = Gem::Platform::RUBY

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  s.add_development_dependency "rspec"
  s.add_dependency "yard"
end
