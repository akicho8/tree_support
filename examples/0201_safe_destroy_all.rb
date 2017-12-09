# An example requiring safe_destroy_all (since acts_as_list is behind, you can roll it with destroy_all)

require "bundler/setup"

require "rails"
require "active_record"
require "tree_support"

begin
  require "acts_as_list"
  ActiveRecord::Base.include(ActiveRecord::Acts::List)
end

Class.new(Rails::Application) { config.eager_load = false }.initialize! # Activate ar_tree_model

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
    t.integer :position
  end
end

class Node < ActiveRecord::Base
  ar_tree_model
  acts_as_list scope: :parent

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
      add "Attack"
    end
  end
end

puts Node.root.to_s_tree
Node.destroy_all rescue $!      # => #<ActiveRecord::RecordNotFound: Couldn't find Node with 'id'=2>
Node.safe_destroy_all
Node.count                      # => 0
# >> *root*
# >> └─Battle
# >>     └─Attack
