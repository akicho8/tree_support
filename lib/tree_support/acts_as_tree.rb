# -*- coding: utf-8 -*-
#
# acts_as_tree の代替品
#
#   class Node < ActiveRecord::Base
#     include TreeSupport::ActsAsTree
#     acts_as_tree
#   end
#
require "active_support/concern"

if $0 == __FILE__
  $LOAD_PATH.unshift("..")
  require "tree_support"
  require "active_record"
end

module TreeSupport
  module ActsAsTree
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_tree(options = {})
        return if acts_as_tree_defined?

        include SingletonMethods

        class_attribute :acts_as_tree_configuration
        self.acts_as_tree_configuration = {
          :order => :id,
        }.merge(options)

        if block_given?
          yield acts_as_tree_configuration
        end

        include Module.new.tap{|m|
          m.instance_exec(acts_as_tree_configuration){|conf|
            # define_method("#{conf[:name]}_at?") do
            #   Time.current.to_i >= send("#{conf[:name]}_at").to_i
            # end
          }
        }
      end

      def acts_as_tree_defined?
        ancestors.include?(SingletonMethods)
      end
    end

    module SingletonMethods
      extend ActiveSupport::Concern
      include Treeable
      include Stringify

      included do
        belongs_to :parent, :class_name => name, :foreign_key => :parent_id
        has_many :children, -> { order(acts_as_tree_configuration[:order]) }, :class_name => name, :foreign_key => :parent_id, :dependent => :destroy, :inverse_of => :parent
      end

      module ClassMethods
        def acts_as_tree?
          acts_as_tree_defined? # && columns_hash.has_key?(:id)
        end

        def roots
          where(:parent_id => nil).order(acts_as_tree_configuration[:order])
        end

        def root
          roots.first
        end

        # def destroy_all_from_leaf
        # end
      end
    end
  end
end

if $0 == __FILE__
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
    include TreeSupport::ActsAsTree
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

  puts root.to_s_tree
end
# >> <root>
# >> ├─交戦
# >> │   ├─攻撃
# >> │   │   ├─剣を振る
# >> │   │   ├─攻撃魔法
# >> │   │   │   ├─召喚A
# >> │   │   │   └─召喚B
# >> │   │   └─縦で剣をはじく
# >> │   └─防御
# >> ├─撤退
# >> │   ├─足止めする
# >> │   │   ├─トラップをしかける
# >> │   │   └─弓矢を放つ
# >> │   └─逃走する
# >> └─休憩
# >>     ├─立ち止まる
# >>     └─回復する
# >>         ├─回復魔法
# >>         └─回復薬を飲む
