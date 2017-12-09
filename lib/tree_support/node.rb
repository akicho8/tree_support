require 'active_support/core_ext/module/delegation' # for Module#delegate.

module TreeSupport
  # Simple node (because it is troublesome to bother to make it on the application side when only wooden structure information is wanted)
  class Node
    include Treeable
    include Stringify

    attr_accessor :attributes, :parent, :children

    alias_method :name, :attributes
    alias_method :key, :attributes

    delegate :[], :[]=, :to_h, to: :attributes

    def initialize(attributes = nil, &block)
      @attributes = attributes
      @children = []
      if block_given?
        instance_eval(&block)
      end
    end

    def add(*args, &block)
      tap do
        children << self.class.new(*args, &block).tap do |v|
          v.parent = self
        end
      end
    end
  end

  def self.example
    Node.new("*root*") do
      add "Battle" do
        add "Attack" do
          add "Shake the sword"
          add "Attack magic" do
            add "Summoner Monster A"
            add "Summoner Monster B"
          end
          add "Repel sword in length"
        end
        add "Defense"
      end
      add "Withdraw" do
        add "To stop" do
          add "Place a trap"
          add "Shoot a bow and arrow"
        end
        add "To escape"
      end
      add "Break" do
        add "Stop"
        add "Recover" do
          add "Recovery magic"
          add "Drink recovery medicine"
        end
      end
    end
  end

  # Methods for easily making trees from data like CSV
  class << self
    # Array -> Tree
    #
    # records = [
    #   {key: :a, parent: nil},
    #   {key: :b, parent: :a},
    #   {key: :c, parent: :b},
    # ]
    #
    # puts TreeSupport.records_to_tree(records).to_s_tree
    # a
    # └─b
    #      └─c
    #          └─d
    #
    # Be sure to have one route
    #
    def records_to_tree(records, key: :key, parent_key: :parent, root_key: nil)
      # Once hashed
      source_hash = records.inject({}) { |a, e| a.merge(e[key] => e) }
      # The node also makes it a hash of only the node having the key
      node_hash = records.inject({}) { |a, e| a.merge(e[key] => Node.new(e[key])) }
      # Link nodes
      node_hash.each_value do |node|
        if parent = source_hash[node.key][parent_key]
          parent_node = node_hash[parent]
          node.parent = parent_node
          parent_node.children << node
        end
      end

      # If the node whose parent was not set is the root (s)
      roots = node_hash.each_value.find_all {|e| e.parent.nil? }

      # Specify root_key when there are multiple routes and you are in trouble. Then create a new route and hang it.
      if root_key
        Node.new(root_key).tap do |root|
          roots.each do |e|
            e.parent = root
            root.children << e
          end
        end
      else
        roots
      end
    end

    # Tree -> Array
    #
    # p TreeSupport.tree_to_records(tree)
    # [
    #   {key: :a, parent: nil},
    #   {key: :b, parent: :a},
    #   {key: :c, parent: :b},
    # ]
    #
    def tree_to_records(root, key: :key, parent_key: :parent)
      root.each_node.collect {|e| {key => e.key, parent_key => e.parent&.key} }
    end
  end
end
