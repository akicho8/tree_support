require "kconv"
require "active_support/concern"
require "active_support/core_ext/module/attribute_accessors" # mattr_accessor

module TreeSupport
  mattr_accessor :name_methods
  self.name_methods = [:to_s_tree_name, :name, :subject, :title]

  def self.tree(*args, &block)
    Inspector.tree(*args, &block)
  end

  def self.node_name(object)
    object.send(name_methods.find {|e| object.respond_to?(e)} || :to_s)
  end

  class Inspector
    def self.tree(object, *args, &block)
      new(*args, &block).tree(object)
    end

    def initialize(**options, &block)
      @options = {
        take: 256,       # Up to depth N (for when the tree can not be displayed because it is huge)
        drop: 0,         # From the depth N (when set to 1 you can hide the route)
        root_label: nil, # A valid alternative label for displaying the route
        tab_space: 4,    # Indent width from halfway
        connect_char: "├",
        tab_visible_char: "│",
        edge_char: "└",
        branch_char: "─",
        debug: false,
      }.merge(options)

      @block = block
    end

    # 木構造の可視化
    #
    #   必要なメソッド
    #     parent.children
    #     name
    #
    def tree(object, **locals)
      locals = {
        depth: [],
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

      indents = locals[:depth].each.with_index.collect {|e, i|
        if i > @options[:drop]
          tab = e ? @options[:tab_visible_char] : ""
          tab.toeuc.ljust(@options[:tab_space]).toutf8
        end
      }.join

      if @block
        label = @block.call(object, locals)
      else
        if locals[:depth].empty? && @options[:root_label] # Change if there is root and alternative label
          label = @options[:root_label]
        else
          label = TreeSupport.node_name(object)
        end
      end

      buffer = ""
      branch_char = nil

      if locals[:depth].size > @options[:drop]
        branch_char = @options[:branch_char]
      end
      if locals[:depth].size < @options[:take]
        if locals[:depth].size >= @options[:drop]
          buffer = "#{indents}#{prefix_char}#{branch_char}#{label}#{@options[:debug] ? locals[:depth].inspect : ""}\n"
        end
      end

      flag = false
      if object.parent
        flag = (object != object.parent.children.last)
      end

      locals[:depth].push(flag)
      if locals[:depth].size < @options[:take]
        buffer << object.children.collect {|node| tree(node, locals)}.join
      end
      locals[:depth].pop

      buffer
    end
  end

  module Stringify
    def to_s_tree(*args, &block)
      Inspector.tree(self, *args, &block)
    end
  end
end

if $0 == __FILE__
  $LOAD_PATH << ".."
  require "tree_support"
  puts TreeSupport.example.to_s_tree(take: 0)
  puts TreeSupport.example.to_s_tree(take: 1)
  puts TreeSupport.example.to_s_tree(take: 2)
end
