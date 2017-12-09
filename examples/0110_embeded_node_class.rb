#
# Built-in TreeSupport::Node can be used generically when you want to express a little tree structure
#
require "bundler/setup"
require "tree_support"

node = TreeSupport::Node.new("foo")
node.name                       # => "foo"

node = TreeSupport::Node.new(:foo)
node.key                        # => :foo

node = TreeSupport::Node.new(a: 1, b: 2)
node[:a]                        # => 1
node.to_h                       # => {:a=>1, :b=>2}

tree = TreeSupport::Node.new(:root) do
  add :a do
    add :b do
      add :c
    end
  end
end

tree.each_node.find { |e| e.key == :root }.key # => :root
tree.each_node.find { |e| e.key == :b }.key    # => :b
