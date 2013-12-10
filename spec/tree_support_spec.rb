# -*- coding: utf-8 -*-
require "spec_helper"

describe TreeSupport do
  it "tree" do
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
    TreeSupport.example.to_s_tree.should == expected
  end

  describe do
    before do
      @tree = TreeSupport::Node.new("<root>") do
        add "a" do
          add "a1"
          add "a2"
          add "a3" do
            add "x"
          end
        end
      end
      @node = @tree.each_node.find{|e|e.name == "a2"}
    end

    it "ancestors" do
      @node.ancestors.collect(&:name).should == ["a2", "a", "<root>"]
    end

    it "root" do
      @node.root.name.should == "<root>"
    end

    it "siblings" do
      @node.siblings.collect(&:name).should == ["a1", "a3"]
    end

    it "self_and_siblings" do
      @node.self_and_siblings.collect(&:name).should == ["a1", "a2", "a3"]
    end
  end
end
