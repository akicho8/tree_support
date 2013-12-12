# -*- coding: utf-8 -*-
#
# TreeSupport::Node の木を ActiveRecord の木に置き換えるイディオム
#
$LOAD_PATH.unshift("../lib")
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

f = -> root, node {
  sub = root.children.create!(:name => node.name)
  node.children.each {|node| f.(sub, node) }
}
root = Node.create!(:name => TreeSupport.example.name)
TreeSupport.example.children.each {|node| f.(root, node)}

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
# >> ├─撤退
# >> │   ├─足止めする
# >> │   │   ├─トラップをしかける
# >> │   │   └─弓矢を放つ
# >> │   └─逃走する
# >> └─休憩
# >>     ├─立ち止まる
# >>     └─回復する
# >>         ├─回復魔法
# >>         └─回復薬を飲む
