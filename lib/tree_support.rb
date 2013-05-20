# -*- coding: utf-8 -*-
# 木構造可視化ライブラリ
#
#   root = TreeSupport::Node.new("ROOT").tap do |n|
#     n.instance_eval do
#       add "A" do
#         add "B" do
#           add "C"
#         end
#       end
#     end
#   end
#
#   puts TreeSupport.tree(root)
#   > ROOT
#   > └─A
#   >     └─B
#   >         └─C

require "kconv"
require "graphviz_r"

module TreeSupport
  def self.tree(*args, &block)
    Inspector.tree(*args, &block)
  end

  def self.graphviz(*args, &block)
    GraphvizBuilder.build(*args, &block)
  end

  def self.gp(*args, &block)
    # require "tempfile"
    # require "pathname"
    # require "securerandom"
    # Dir.mktmpdir do |dir|
    #   filename = "#{dir}/#{SecureRandom.hex}.png"
    #   graphviz(*args, &block).output(filename)
    #   `open #{filename}`
    # end

    filename = "_output.png"
    graphviz(*args, &block).output(filename)
    `open #{filename}`
  end

  def self.node_name(object)
    if object.respond_to?(:to_s_tree)
      object.to_s_tree
    elsif object.respond_to?(:name)
      object.name
    else
      object.to_s
    end
  end

  class Inspector
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
    #     parent.children
    #     to_s_tree
    #
    def tree(object, locals = {})
      locals = {
        :depth => [],
      }.merge(locals)

      if locals[:depth].size > @options[:skip]
        if object == object.parent.children.last
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
          label = TreeSupport.node_name(object)
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
        flag = (object != object.parent.children.last)
      end

      locals[:depth].push(flag)
      buffer << object.children.collect{|node|tree(node, locals)}.join
      locals[:depth].pop

      buffer
    end
  end

  module Model
    def tree(options = {}, &block)
      Inspector.tree(self, options, &block)
    end
  end

  class GraphvizBuilder
    def self.build(object, *args, &block)
      new(*args, &block).build(object)
    end

    def initialize(options = {}, &block)
      @options = {
      }.merge(options)
      @block = block
    end

    def build(object)
      gv = GraphvizR.new(node_code(object))
      gv.graph[:charset => "UTF-8", :rankdir => "LR"]
      visit(gv, object)
      gv
    end

    private

    def visit(gv, object)
      gv[node_code(object)][:label => TreeSupport.node_name(object)]
      unless object.children.empty?
        gv[node_code(object)] >> object.children.collect{|node|gv[node_code(node)]}
        object.children.each{|node|visit(gv, node)}
      end
      if @block
        if attrs = @block.call(object)
          unless attrs.empty?
            gv[node_code(object)][attrs]
          end
        end
      end
    end

    def node_code(object)
      "n#{object.object_id}"
    end
  end

  # シンプルなノード(すぐにコードを書きたいときに使う)
  class Node
    include Model

    attr_accessor :name, :parent, :children

    def initialize(name)
      @name = name
      @children = []
    end

    def to_s_tree
      @name
    end

    # Builder pattern (?)
    def add(name, &block)
      tap do
        node = self.class.new(name)
        node.parent = self
        @children << node
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

  gv = TreeSupport.graphviz(root)
  puts gv.to_dot
  gv.output("_output1.png")

  gv = TreeSupport.graphviz(root){|node|
    if node.name.include?("攻")
      {:fillcolor => "lightblue", :style => "filled"}
    elsif node.name.include?("回復")
      {:fillcolor => "lightpink", :style => "filled"}
    end
  }
  gv.output("_output2.png")

  TreeSupport.gp(root)
end
