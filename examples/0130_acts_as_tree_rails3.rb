# -*- coding: utf-8 -*-
# acts_as_tree_rails3 を使ったモデルの可視化
#
require "../lib/tree_support"

gem "activerecord", "3.2.13"
require "active_record"
require "acts_as_tree_rails3"
require "pp"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  acts_as_tree

  def add(name, &block)
    tap do
      child = children.create!(:name => name)
      if block_given?
        child.instance_eval(&block)
      end
    end
  end
end

root = Node.create!(:name => "<root>").tap do |n|
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

puts TreeSupport.tree(root)
