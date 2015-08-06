# -*- coding: utf-8 -*-
#
# TreeSupport::Node の木を ActiveRecord の木に置き換えるイディオム
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

# 方法1. シンプルだけどユニークキー相当が必須になってしまう
Node.destroy_all
TreeSupport.example.each_node do |node|
  obj = Node.find_or_initialize_by(:name => node.name) # 更新するために find_or にしている
  if node.parent
    obj.parent = Node.find_by(:name => node.parent.name) # ← ユニークキーがないとここで引くのが難しい
  else
    obj.parent = nil
  end
  obj.save!
end
root = Node.find_by(:name => TreeSupport.example.name)
puts TreeSupport.tree(root)

# 方法2. 子が作られるときは親がかならず存在することを利用して方法1を改良
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

# 方法3. 再帰にするとユニークキーは不要。だけど create! が二箇所なのがちょっと。更新が難しい(？)
Node.destroy_all
def create_recursion(root, node)
  sub = root.children.create!(:name => node.name)
  node.children.each {|node| create_recursion(sub, node) }
end
root = Node.create!(:name => TreeSupport.example.name)
TreeSupport.example.children.each {|node| create_recursion(root, node)}
puts TreeSupport.tree(root)

# >> *root*
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
# >> *root*
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
# >> *root*
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
