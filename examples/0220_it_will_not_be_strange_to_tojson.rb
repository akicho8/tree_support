# It will not be strange to tojson
#
require "bundler/setup"

require "rails"
require "active_record"
require "tree_support"
require "byebug"

Class.new(Rails::Application){config.eager_load = false}.initialize! # In order to read Railtie

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :nodes do |t|
    t.belongs_to :parent
    t.string :name
  end
end

class Node < ActiveRecord::Base
  ar_tree_model
end

Node.create!(name: "*root*")
Node.first.to_json              # => "{\"id\":1,\"parent_id\":null,\"name\":\"*root*\"}"
