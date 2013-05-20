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

    expected = <<-EOT
<root>
├─交戦
│   ├─攻撃
│   │   ├─剣を振る
│   │   ├─攻撃魔法
│   │   │   ├─召喚A
│   │   │   └─召喚B
│   │   └─縦で剣をはじく
│   └─防御
├─撤退
│   ├─足止めする
│   │   ├─トラップをしかける
│   │   └─弓矢を放つ
│   └─逃走する
└─休憩
    ├─立ち止まる
    └─回復する
        ├─回復魔法
        └─回復薬を飲む
EOT

    root.tree.should == expected
    TreeSupport.tree(root).should == expected
  end
end
