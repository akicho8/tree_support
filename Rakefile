# -*- coding: utf-8 -*-
require "bundler"
Bundler::GemHelper.install_tasks

task :default => :test

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  # t.test_files = FileList['test/test*.rb']
  # t.verbose = true
  # t.options = "--no-use-color"
end
