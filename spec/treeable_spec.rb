# -*- coding: utf-8 -*-
require "spec_helper"

describe TreeSupport::Treeable do
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

  it "root?" do
    @node.root?.should == false
  end

  it "leaf?" do
    @node.leaf?.should == true
  end
end
