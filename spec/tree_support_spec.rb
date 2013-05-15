# -*- coding: utf-8 -*-
require "spec_helper"

describe do
  it do
    root = TreeSupport::Node.new("<root>").tap do |n|
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

    puts root.tree
    puts TreeSupport.tree(root)
  end
end
