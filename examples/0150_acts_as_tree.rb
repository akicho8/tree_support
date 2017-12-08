# -*- coding: utf-8 -*-
#
# acts_as_tree を使った例
#
require "bundler/setup"
require "tree_support"
require "active_record"

begin
  require "acts_as_tree"
  ActiveRecord::Base.include(ActsAsTree)
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  acts_as_tree :order => "name"

  def add(name, &block)
    tap do
      child = children.create!(:name => name)
      if block_given?
        child.instance_eval(&block)
      end
    end
  end
end

_root = Node.create!(:name => "*root*").tap do |n|
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

Node.extend(ActsAsTree::TreeView)
Node.tree_view(:name)

# puts TreeSupport.tree(root)
# ~> 	from -:10:in  `<main>'
# ~> 	from -:10:in  `require'
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
# >>  |    |_ 交戦
# >>  |        |_ 攻撃
# >>  |            |_ 剣を振る
# >>  |            |_ 攻撃魔法
# >>  |                |_ 召喚A
# >>  |                |_ 召喚B
# >>  |            |_ 縦で剣をはじく
# >>  |        |_ 防御
# >>  |    |_ 休憩
# >>  |        |_ 回復する
# >>  |            |_ 回復薬を飲む
# >>  |            |_ 回復魔法
# >>  |        |_ 立ち止まる
# >>  |    |_ 撤退
# >>  |        |_ 足止めする
# >>  |            |_ トラップをしかける
# >>  |            |_ 弓矢を放つ
# >>  |        |_ 逃走する
