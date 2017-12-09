# -*- coding: utf-8 -*-
#
# Idiom replacing TreeSupport::Node's tree with ActiveRecord's tree
#
require "bundler/setup"
require "tree_support"
require "active_record"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  belongs_to :parent, :class_name => name, :foreign_key => :parent_id
  has_many :children, :class_name => name, :foreign_key => :parent_id
end

# METHOD 1. It is simple but unique key equivalent becomes essential
Node.destroy_all
TreeSupport.example.each_node do |node|
  obj = Node.find_or_initialize_by(:name => node.name) # I'm doing find_or to update
  if node.parent
    obj.parent = Node.find_by(:name => node.parent.name) # It is difficult to draw here without a unique key
  else
    obj.parent = nil
  end
  obj.save!
end
root = Node.find_by(:name => TreeSupport.example.name)
puts TreeSupport.tree(root)

# METHOD 2. Improve method 1 by making sure that parents are always present when children are made
Node.destroy_all
stock = {}
TreeSupport.example.each_node do |node|
  obj = Node.find_or_initialize_by(:name => node.name)
  if node.parent
    obj.parent = stock[node.parent]
  else
    obj.parent = nil
  end
  obj.save!
  stock[node] = obj
end
root = Node.find_by(:name => TreeSupport.example.name)
puts TreeSupport.tree(root)

# Method 3. Unnecessary to use a unique key when recursive. However, it is a bit that create! Is two places. Update is difficult (?)
Node.destroy_all
def create_recursion(root, node)
  sub = root.children.create!(:name => node.name)
  node.children.each {|node| create_recursion(sub, node) }
end
root = Node.create!(:name => TreeSupport.example.name)
TreeSupport.example.children.each {|node| create_recursion(root, node)}
puts TreeSupport.tree(root)

# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Shake the sword
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoner Monster A
# >> │   │   │   └─Summoner Monster B
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
# >> │   │   │   ├─Summoner Monster A
# >> │   │   │   └─Summoner Monster B
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
# >> │   │   │   ├─Summoner Monster A
# >> │   │   │   └─Summoner Monster B
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
