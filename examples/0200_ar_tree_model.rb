# -*- coding: utf-8 -*-
#
# An example using TreeSupport::ArTreeModel of alternate library of acts_as_tree
#
require "bundler/setup"

require "rails"
require "active_record"
require "tree_support"

Class.new(Rails::Application) { config.eager_load = false }.initialize! # Activate ar_tree_model

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  ar_tree_model scope: -> { order(:name).where.not(name: "Break") }

  def add(name, &block)
    tap do
      child = children.create!(name: name)
      if block_given?
        child.instance_eval(&block)
      end
    end
  end
end

Node.create!(name: "*root*").tap do |n|
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

puts Node.root.to_s_tree
Node.destroy_all             # Because it does not use acts_as_list, it can be erased

# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoned Beast X
# >> │   │   │   └─Summoned Beast Y
# >> │   │   ├─Repel sword in length
# >> │   │   └─Shake the sword
# >> │   └─Defense
# >> └─Withdraw
# >>     ├─To escape
# >>     └─To stop
# >>         ├─Place a trap
# >>         └─Shoot a bow and arrow
