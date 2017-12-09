require "spec_helper"

require "rails"
require "tree_support/ar_tree_model"
require "tree_support/railtie"
require "active_record"

Class.new(Rails::Application){config.eager_load = true}.initialize!

RSpec.describe "ArTreeModel" do
  before do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Schema.define do
      create_table :nodes do |t|
        t.belongs_to :parent
        t.string :name
      end
    end

    class Node < ActiveRecord::Base
      ar_tree_model order: "name"

      def add(name, &block)
        tap do
          child = children.create!(name: name)
          if block_given?
            child.instance_eval(&block)
          end
        end
      end
    end

    @node = Node.create!(name: "*root*").tap do |n|
      n.instance_eval do
        add "Battle" do
          add "Attack" do
            add "Shake the sword"
            add "Attack magic" do
              add "Summoned Beast X"
              add "Summoned Beast Y"
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
  end

  it "roots" do
    Node.roots.should == [@node]
  end

  it "root" do
    Node.root.should == @node
  end

  it "to_s_tree" do
    @node.to_s_tree
  end

  it "safe_destroy_all" do
    Node.safe_destroy_all
    Node.count.should == 0
  end
end
