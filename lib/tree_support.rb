# -*- coding: utf-8 -*-
require "kconv"

module TreeSupport
  def self.tree(*args, &block)
    Dump.tree(*args, &block)
  end

  class Dump
    def self.tree(object, *args, &block)
      new(*args, &block).tree(object)
    end

    def initialize(options = {}, &block)
      @options = {
        # オプション相当
        :skip             => 0,     # 何レベルスキップするか？(1にするとrootを表示しない)
        :root_label       => nil,   # ルートを表示する場合に有効な代替ラベル
        :tab_space        => 4,     # 途中からのインデント幅
        :connect_char     => "├",
        :tab_visible_char => "│",
        :edge_char        => "└",
        :branch_char      => "─",
        :debug            => false, # わけがわからなくなったら true にしよう
      }.merge(options)
      @block = block
    end

    # 木構造の可視化
    #
    #   必要なメソッド
    #     parent.nodes
    #     to_s_tree
    #
    def tree(object, locals = {})
      locals = {
        :depth => [],
      }.merge(locals)

      if locals[:depth].size > @options[:skip]
        if object == object.parent.nodes.last
          prefix_char = @options[:edge_char]
        else
          prefix_char = @options[:connect_char]
        end
      else
        prefix_char = ""
      end

      indents = locals[:depth].each.with_index.collect{|flag, index|
        if index > @options[:skip]
          tab = flag ? @options[:tab_visible_char] : ""
          tab.toeuc.ljust(@options[:tab_space]).toutf8
        end
      }.join

      if @block
        label = @block.call(object, locals[:depth])
      else
        if locals[:depth].empty? && @options[:root_label] # ルートかつ代替ラベルがあれば変更
          label = @options[:root_label]
        else
          label = object.respond_to?(:to_s_tree) ? object.to_s_tree : object.to_s
        end
      end

      branch_char = nil
      if locals[:depth].size > @options[:skip]
        branch_char = @options[:branch_char]
      end

      if locals[:depth].size >= @options[:skip]
        buffer = "#{indents}#{prefix_char}#{branch_char}#{label}#{@options[:debug] ? locals[:depth].inspect : ""}\n"
      else
        buffer = ""
      end

      flag = false
      if object.parent
        flag = (object != object.parent.nodes.last)
      end

      locals[:depth].push(flag)
      buffer << object.nodes.collect{|node|tree(node, locals)}.join
      locals[:depth].pop

      buffer
    end
  end

  module Model
    def tree(options = {}, &block)
      Dump.tree(self, options, &block)
    end
  end

  # シンプルなノード(別に継承する必要はない)
  class Node
    include Model

    attr_accessor :name, :parent, :nodes

    def initialize(name)
      @name = name
      @nodes = []
    end

    def to_s_tree
      @name
    end

    # Builder pattern (?)
    def add(name, &block)
      tap do
        node = self.class.new(name)
        node.parent = self
        @nodes << node
        if block_given?
          node.instance_eval(&block)
        end
      end
    end
  end
end

if $0 == __FILE__
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
