# Example using acts_as_tree
#
require "bundler/setup"
require "tree_support"
require "active_record"

begin
  require "acts_as_tree"
  ActiveRecord::Base.include(ActsAsTree)
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  acts_as_tree order: "name"

  def add(name, &block)
    tap do
      child = children.create!(name: name)
      if block_given?
        child.instance_eval(&block)
      end
    end
  end
end

_root = Node.create!(name: "*root*").tap do |n|
  n.instance_eval do
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
end

Node.extend(ActsAsTree::TreeView)
Node.tree_view(:name)

# puts TreeSupport.tree(root)
# >> root
# >>  |_ *root*
# >>  |    |_ Battle
# >>  |        |_ Attack
# >>  |            |_ Attack magic
# >>  |                |_ Summoned Beast X
# >>  |                |_ Summoned Beast Y
# >>  |            |_ Repel sword in length
# >>  |            |_ Shake the sword
# >>  |        |_ Defense
# >>  |    |_ Break
# >>  |        |_ Recover
# >>  |            |_ Drink recovery medicine
# >>  |            |_ Recovery magic
# >>  |        |_ Stop
# >>  |    |_ Withdraw
# >>  |        |_ To escape
# >>  |        |_ To stop
# >>  |            |_ Place a trap
# >>  |            |_ Shoot a bow and arrow
