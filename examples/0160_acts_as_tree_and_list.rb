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

# Node.extend(ArTreeModel::TreeView)
# Node.tree_view(:name)

puts TreeSupport.tree(root) {|e| "#{e.name}(#{e.position})"}

# acts_as_tree + acts_as_list は destroy_all で事故る
Node.destroy_all rescue $!      # => #<ActiveRecord::RecordNotFound: Couldn't find Node with 'id'=2>
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
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/activerecord-5.0.0/lib/active_record/sanitization.rb:163: warning: too many arguments for format string
# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/arel-7.1.0/lib/arel/nodes/casted.rb:14: warning: instance variable @class not initialized
# ~> !XMP1512801308_58182_9031![1] => ActiveRecord::RecordNotFound #<ActiveRecord::RecordNotFound: Couldn't find Node with 'id'=2>
# ~> root
# ~> _xmp_1512801308_58182_55846
# >> *root*(1)
# >> ├─Battle(1)
# >> │   ├─Attack(1)
# >> │   │   ├─Shake the sword(1)
# >> │   │   ├─Attack magic(2)
# >> │   │   │   ├─Summoner Monster A(1)
# >> │   │   │   └─Summoner Monster B(2)
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
