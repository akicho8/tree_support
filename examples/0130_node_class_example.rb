# Examples of homebrew nodes

require "bundler/setup"
require "tree_support"

class Node
  attr_accessor :name, :parent, :children

  def initialize(name = nil, &block)
    @name = name
    @children = []
    if block_given?
      instance_eval(&block)
    end
  end

  # 木を簡単につくるため
  def add(*args, &block)
    tap do
      children << self.class.new(*args, &block).tap do |v|
        v.parent = self
      end
    end
  end
end

root = Node.new("*root*") do
  add "Battle" do
    add "Attack" do
      add "Shake the sword"
      add "Attack magic" do
        add "Summoned Beast X"
        add "Summoned Beast Y"
      end
      add "Repel sword in length"
    end
    add "Defense"
  end
  add "Withdraw" do
    add "To stop" do
      add "Place a trap"
      add "Shoot a bow and arrow"
    end
    add "To escape"
  end
  add "Break" do
    add "Stop"
    add "Recover" do
      add "Recovery magic"
      add "Drink recovery medicine"
    end
  end
end

# The object passed to TreeSupport.tree needs only to respond to parent.children and name
puts TreeSupport.tree(root)

# How do I put a method to stringify an object?
Node.include(TreeSupport::Stringify)
puts root.to_s_tree
# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Shake the sword
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoned Beast X
# >> │   │   │   └─Summoned Beast Y
# >> │   │   └─Repel sword in length
# >> │   └─Defense
# >> ├─Withdraw
# >> │   ├─To stop
# >> │   │   ├─Place a trap
# >> │   │   └─Shoot a bow and arrow
# >> │   └─To escape
# >> └─Break
# >>     ├─Stop
# >>     └─Recover
# >>         ├─Recovery magic
# >>         └─Drink recovery medicine
# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Shake the sword
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoned Beast X
# >> │   │   │   └─Summoned Beast Y
# >> │   │   └─Repel sword in length
# >> │   └─Defense
# >> ├─Withdraw
# >> │   ├─To stop
# >> │   │   ├─Place a trap
# >> │   │   └─Shoot a bow and arrow
# >> │   └─To escape
# >> └─Break
# >>     ├─Stop
# >>     └─Recover
# >>         ├─Recovery magic
# >>         └─Drink recovery medicine
