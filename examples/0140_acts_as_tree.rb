# -*- coding: utf-8 -*-
#
# acts_as_tree_rails3 を使ったモデルの可視化
#
$LOAD_PATH.unshift("../lib")
require "tree_support"

require "active_record"
require "acts_as_tree"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  include ActsAsTree
  acts_as_tree order: "name"

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

puts TreeSupport.tree(root)
# >> <root>
# >> ├─交戦
# >> │   ├─攻撃
# >> │   │   ├─剣を振る
# >> │   │   ├─攻撃魔法
# >> │   │   │   ├─召喚A
# >> │   │   │   └─召喚B
# >> │   │   └─縦で剣をはじく
# >> │   └─防御
# >> ├─休憩
# >> │   ├─回復する
# >> │   │   ├─回復薬を飲む
# >> │   │   └─回復魔法
# >> │   └─立ち止まる
# >> └─撤退
# >>     ├─足止めする
# >>     │   ├─トラップをしかける
# >>     │   └─弓矢を放つ
# >>     └─逃走する
