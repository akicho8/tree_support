# -*- coding: utf-8 -*-
#
# 自作ノードの例
#
require "bundler/setup"
require "tree_support"

class Node
  attr_accessor :name, :parent, :children

  def initialize(name = nil, &block)
    @name = name
    @children = []
    if block_given?
      instance_eval(&block)
    end
  end

  # 木を簡単につくるため
  def add(*args, &block)
    tap do
      children << self.class.new(*args, &block).tap{|v|v.parent = self}
    end
  end
end

root = Node.new("*root*") do
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

# TreeSupport.tree に渡すオブジェクトは は parent.children と name に応答できさえすればいい
puts TreeSupport.tree(root)

# オブジェクトに文字列化するメソッドを入れるには？
Node.include(TreeSupport::Stringify)
puts root.to_s_tree
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
