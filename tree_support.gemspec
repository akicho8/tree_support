# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tree_support/version'

Gem::Specification.new do |s|
  s.name         = "tree_support"
  s.version      = TreeSupport::VERSION
  s.author       = "akicho8"
  s.email        = "akicho8@gmail.com"
  s.homepage     = "https://github.com/akicho8/tree_support"
  s.summary      = "Tree structure visualization function library"
  s.description  = "Tree structure visualization function library"
  s.platform     = Gem::Platform::RUBY

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--charset=UTF-8", "--diagram", "--image-format=jpg"]

  s.add_dependency "activesupport"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rails"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "gviz"
end
