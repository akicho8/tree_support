require 'active_support/core_ext/module/delegation' # for Module#delegate.

module TreeSupport
  # シンプルなノード(木構造の情報だけが欲しいときアプリ側でわざわざ作るのも面倒なので)
  class Node
    include Treeable
    include Stringify

    attr_accessor :attributes, :parent, :children

    alias_method :name, :attributes
    alias_method :key, :attributes

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
        children << self.class.new(*args, &block).tap {|v| v.parent = self}
      end
    end
  end

  def self.example
    Node.new("*root*") do
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

  # CSVのようなデータから木を簡単に作るためのメソッドたち
  class << self
    # 配列→木
    #
    # records = [
    #   {:key => :a, :parent => nil},
    #   {:key => :b, :parent => :a},
    #   {:key => :c, :parent => :b},
    # ]
    #
    # puts TreeSupport.records_to_tree(records).to_s_tree
    # a
    # └─b
    #      └─c
    #          └─d
    #
    # ※ルートは必ず一つとすること
    #
    def records_to_tree(records, key: :key, parent_key: :parent, root_key: nil)
      # いったんハッシュ化
      source_hash = records.inject({}) { |a, e| a.merge(e[key] => e) }
      # ノードの方も、キーを持っただけのノードのハッシュにしておく
      node_hash = records.inject({}) { |a, e| a.merge(e[key] => Node.new(e[key])) }
      # ノードを連結していく
      node_hash.each_value { |node|
        if parent = source_hash[node.key][parent_key]
          parent_node = node_hash[parent]
          node.parent = parent_node
          parent_node.children << node
        end
      }

      # 親が設定されなかったノードがルート(複数)
      roots = node_hash.each_value.find_all {|e| e.parent.nil? }

      # ルートが複数あって困るときは root_key を指定する。
      # そうすれば新しくルートを一つ作ってぶら下げる。
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

    # 木→配列
    #
    # p TreeSupport.tree_to_records(tree)
    # [
    #   {:key => :a, :parent => nil},
    #   {:key => :b, :parent => :a},
    #   {:key => :c, :parent => :b},
    # ]
    #
    def tree_to_records(root, key: :key, parent_key: :parent)
      root.each_node.collect {|e| {key => e.key, parent_key => e.parent&.key} }
    end
  end
end
