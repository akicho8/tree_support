# -*- coding: utf-8 -*-
require "spec_helper"

describe do
  it do
    root = Node.new("<root>").tap do |n|
      n.add("交戦") do |n|
        n.add("攻撃") do |n|
          n.add("剣を振る")
          n.add("攻撃魔法") do |n|
            n.add("召喚A")
            n.add("召喚B")
          end
          n.add("縦で剣をはじく")
        end
        n.add("防御")
      end
      n.add("撤退") do |n|
        n.add("足止めする") do |n|
          n.add("トラップをしかける")
          n.add("弓矢を放つ")
        end
        n.add("逃走する")
      end
      n.add("休憩") do |n|
        n.add("立ち止まる")
        n.add("回復する") do |n|
          n.add("回復魔法")
          n.add("回復薬を飲む")
        end
      end
    end

    puts root.tree
    puts TreeSupport.tree(root)
  end
end
