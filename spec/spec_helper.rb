$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "tree_support"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end
end
