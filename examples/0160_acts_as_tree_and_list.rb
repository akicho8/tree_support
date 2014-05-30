# -*- coding: utf-8 -*-
#
# acts_as_tree で兄妹の順序を acts_as_list で保持する例
#
$LOAD_PATH.unshift("../lib")
require "tree_support"

require "active_record"

require "acts_as_tree"
ActiveRecord::Base.send(:include, ActsAsTree)

require "acts_as_list"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
    t.integer :position
  end
end

class Node < ActiveRecord::Base
  acts_as_tree :order => "position"
  acts_as_list :scope => :parent

  def add(name, &block)
    tap do
      child = children.create!(:name => name)
      if block_given?
        child.instance_eval(&block)
      end
    end
  end
end

root = Node.create!(:name => "<root>").tap do |n|
  n.instance_eval do
    add "交戦" do
      add "攻撃" do
        add "剣を振る"
        add "攻撃魔法" do
          add "召喚A"
          add "召喚B"
        end
        add "縦で剣をはじく"
      end
      add "防御"
    end
    add "撤退" do
      add "足止めする" do
        add "トラップをしかける"
        add "弓矢を放つ"
      end
      add "逃走する"
    end
    add "休憩" do
      add "立ち止まる"
      add "回復する" do
        add "回復魔法"
        add "回復薬を飲む"
      end
    end
  end
end

# Node.extend(ActsAsTree::Presentation)
# puts Node.tree_view(:name)

puts TreeSupport.tree(root){|e|"#{e.name}(#{e.position})"}
# ~> 	from -:10:in  `<main>'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:144:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135:in  `rescue in require'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:135:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/gems/2.1.0/gems/acts_as_tree-1.6.0/lib/acts_as_tree.rb:250:in  `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:73:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:73:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/gems/2.1.0/gems/acts_as_tree-1.6.0/lib/acts_as_tree/active_record/acts/tree.rb:1:in  `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:73:in  `require'
# ~> 	from /usr/local/var/rbenv/versions/2.1.1/lib/ruby/2.1.0/rubygems/core_ext/kernel_require.rb:73:in  `require'
# ~> lib/rational.rb is deprecated
# ~> /usr/local/var/rbenv/versions/2.1.1/lib/ruby/gems/2.1.0/gems/tzinfo-1.1.0/lib/tzinfo/ruby_data_source.rb:62: warning: assigned but unused variable - info
# >> <root>(1)
# >> ├─交戦(1)
# >> │   ├─攻撃(1)
# >> │   │   ├─剣を振る(1)
# >> │   │   ├─攻撃魔法(2)
# >> │   │   │   ├─召喚A(1)
# >> │   │   │   └─召喚B(2)
# >> │   │   └─縦で剣をはじく(3)
# >> │   └─防御(2)
# >> ├─撤退(2)
# >> │   ├─足止めする(1)
# >> │   │   ├─トラップをしかける(1)
# >> │   │   └─弓矢を放つ(2)
# >> │   └─逃走する(2)
# >> └─休憩(3)
# >>     ├─立ち止まる(1)
# >>     └─回復する(2)
# >>         ├─回復魔法(1)
# >>         └─回復薬を飲む(2)
