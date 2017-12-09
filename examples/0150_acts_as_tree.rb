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
          add "Summoner Monster A"
          add "Summoner Monster B"
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
# ~> 	from -:8:in  `<main>'
# ~> 	from -:8:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/acts_as_tree-2.4.0/lib/acts_as_tree.rb:322:in  `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/acts_as_tree-2.4.0/lib/acts_as_tree.rb:322:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/acts_as_tree-2.4.0/lib/acts_as_tree/active_record/acts/tree.rb:1:in  `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/acts_as_tree-2.4.0/lib/acts_as_tree/active_record/acts/tree.rb:1:in  `require'
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activesupport-5.0.0/lib/active_support/core_ext/hash/transform_values.rb:11: warning: method redefined; discarding old transform_values
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activesupport-5.0.0/lib/active_support/core_ext/hash/transform_values.rb:23: warning: method redefined; discarding old transform_values!
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/concurrent-ruby-1.0.2/lib/concurrent/map.rb:230: warning: constant ::Fixnum is deprecated
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/concurrent-ruby-1.0.2/lib/concurrent/map.rb:230: warning: constant ::Fixnum is deprecated
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/concurrent-ruby-1.0.2/lib/concurrent/map.rb:230: warning: constant ::Fixnum is deprecated
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/concurrent-ruby-1.0.2/lib/concurrent/map.rb:230: warning: constant ::Fixnum is deprecated
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/arel-7.1.0/lib/arel/nodes/casted.rb:14: warning: instance variable @class not initialized
# >> root
# >>  |_ *root*
# >>  |    |_ Battle
# >>  |        |_ Attack
# >>  |            |_ Attack magic
# >>  |                |_ Summoner Monster A
# >>  |                |_ Summoner Monster B
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
