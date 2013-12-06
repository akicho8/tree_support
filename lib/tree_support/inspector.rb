# -*- coding: utf-8 -*-
require "kconv"
require "active_support/concern"

module TreeSupport
  def self.tree(*args, &block)
    Inspector.tree(*args, &block)
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
        :drop             => 0,     # 何レベルスキップするか？(1にするとrootを表示しない)
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

      if locals[:depth].size > @options[:drop]
        if object == object.parent.children.last
          prefix_char = @options[:edge_char]
        else
          prefix_char = @options[:connect_char]
        end
      else
        prefix_char = ""
      end

      indents = locals[:depth].each.with_index.collect{|flag, index|
        if index > @options[:drop]
          tab = flag ? @options[:tab_visible_char] : ""
          tab.toeuc.ljust(@options[:tab_space]).toutf8
        end
      }.join

      if @block
        label = @block.call(object, locals)
      else
        if locals[:depth].empty? && @options[:root_label] # ルートかつ代替ラベルがあれば変更
          label = @options[:root_label]
        else
          label = TreeSupport.node_name(object)
        end
      end

      branch_char = nil
      if locals[:depth].size > @options[:drop]
        branch_char = @options[:branch_char]
      end

      if locals[:depth].size >= @options[:drop]
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
end
