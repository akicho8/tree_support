# -*- coding: utf-8 -*-
require "spec_helper"

RSpec.describe "Treeable" do
  before do
    @root = TreeSupport::Node.new("*root*") do
      add "a" do
        add "a1"
        add "a2" do
          add "x"
        end
        add "a3"
      end
    end
    @a2 = @root.each_node.find {|e| e.name == "a2"}
    @leaf = @root.each_node.find {|e| e.name == "x"}
  end

  it "ancestors" do
    @a2.ancestors.collect(&:name).should == ["a2", "a", "*root*"]
  end

  it "descendants" do
    @root.descendants.collect(&:name).should == ["a", "a1", "a2", "x", "a3"]
  end

  it "self_and_descendants" do
    @root.self_and_descendants.collect(&:name).should == ["*root*", "a", "a1", "a2", "x", "a3"]
  end

  it "each_node" do
    @root.each_node.collect(&:name).should == ["*root*", "a", "a1", "a2", "x", "a3"]
  end

  it "root" do
    @a2.root.name.should == "*root*"
  end

  it "siblings" do
    @a2.siblings.collect(&:name).should == ["a1", "a3"]
  end

  it "self_and_siblings" do
    @a2.self_and_siblings.collect(&:name).should == ["a1", "a2", "a3"]
  end

  it "root?" do
    @root.root?.should == true
    @leaf.root?.should == false
  end

  it "leaf?" do
    @root.leaf?.should == false
    @leaf.leaf?.should == true
  end
end
