# -*- coding: utf-8 -*-
require "spec_helper"

RSpec.describe "TreeSupport" do
  it "tree" do
    expected = <<-EOT
*root*
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
    TreeSupport.example.to_s_tree.should == expected
  end
end
