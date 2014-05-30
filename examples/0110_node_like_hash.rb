# -*- coding: utf-8 -*-
#
# TreeSupport::Node は汎用的に使える
#
$LOAD_PATH.unshift("../lib")
require "tree_support"

node = TreeSupport::Node.new("foo")
node.name                       # => "foo"

node = TreeSupport::Node.new(:foo)
node.key                        # => :foo

node = TreeSupport::Node.new(:a => 1, :b => 2)
node[:a]                        # => 1
node.to_h                       # => {:a=>1, :b=>2}
