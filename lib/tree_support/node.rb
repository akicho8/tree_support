# -*- coding: utf-8 -*-
module TreeSupport
  # シンプルなノード(木構造の情報だけが欲しいときアプリ側でわざわざ作るのも面倒なので)
  class Node
    include Treeable
    include Stringify

    attr_accessor :attributes, :parent, :children

    alias name attributes
    alias key attributes

    delegate :[], :[]=, :to_h, :to => :attributes

    def initialize(attributes = nil, &block)
      @attributes = attributes
      @children = []
      if block_given?
        instance_eval(&block)
      end
    end

    def add(*args, &block)
      tap do
        children << self.class.new(*args, &block).tap{|v|v.parent = self}
      end
    end
  end

  def self.example
    Node.new("<root>") do
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
end
