# -*- coding: utf-8 -*-
require "test_helper"

class TestTreeable < Test::Unit::TestCase
  setup do
    @root = TreeSupport::Node.new("*root*") do
      add "a" do
        add "a1"
        add "a2" do
          add "x"
        end
        add "a3"
      end
    end
    @a2 = @root.each_node.find{|e|e.name == "a2"}
    @leaf = @root.each_node.find{|e|e.name == "x"}
  end

  test "ancestors" do
    assert_equal ["a2", "a", "*root*"], @a2.ancestors.collect(&:name) 
  end

  test "descendants" do
    assert_equal ["a", "a1", "a2", "x", "a3"], @root.descendants.collect(&:name) 
  end

  test "each_node" do
    assert_equal ["*root*", "a", "a1", "a2", "x", "a3"], @root.each_node.collect(&:name) 
  end

  test "root" do
    assert_equal "*root*", @a2.root.name
  end

  test "siblings" do
    assert_equal ["a1", "a3"], @a2.siblings.collect(&:name)
  end

  test "self_and_siblings" do
    assert_equal ["a1", "a2", "a3"], @a2.self_and_siblings.collect(&:name) 
  end

  test "root?" do
    assert_equal true, @root.root?
    assert_equal false, @leaf.root?
  end

  test "leaf?" do
    assert_equal false, @root.leaf?
    assert_equal true, @leaf.leaf?
  end
end
