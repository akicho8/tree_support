# Example of holding sibling's order in acts_as_list with acts_as_tree
#
require "bundler/setup"
require "tree_support"
require "active_record"

begin
  require "acts_as_tree"
  ActiveRecord::Base.include(ActsAsTree)
end

begin
  require "acts_as_list"
  ActiveRecord::Base.include(ActiveRecord::Acts::List)
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
    t.integer :position
  end
end

class Node < ActiveRecord::Base
  acts_as_tree order: "position"
  acts_as_list scope: :parent

  def add(name, &block)
    tap do
      child = children.create!(name: name)
      if block_given?
        child.instance_eval(&block)
      end
    end
  end
end

root = Node.create!(name: "*root*").tap do |n|
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

# Node.extend(ArTreeModel::TreeView)
# Node.tree_view(:name)

puts TreeSupport.tree(root) {|e| "#{e.name}(#{e.position})"}

# acts_as_tree + acts_as_list accident in destroy_all
Node.destroy_all rescue $!      # => #<ActiveRecord::RecordNotFound: Couldn't find Node with 'id'=2>
# >> *root*(1)
# >> ├─Battle(1)
# >> │   ├─Attack(1)
# >> │   │   ├─Shake the sword(1)
# >> │   │   ├─Attack magic(2)
# >> │   │   │   ├─Summoned Beast X(1)
# >> │   │   │   └─Summoned Beast Y(2)
# >> │   │   └─Repel sword in length(3)
# >> │   └─Defense(2)
# >> ├─Withdraw(2)
# >> │   ├─To stop(1)
# >> │   │   ├─Place a trap(1)
# >> │   │   └─Shoot a bow and arrow(2)
# >> │   └─To escape(2)
# >> └─Break(3)
# >>     ├─Stop(1)
# >>     └─Recover(2)
# >>         ├─Recovery magic(1)
# >>         └─Drink recovery medicine(2)
