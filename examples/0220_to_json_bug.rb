# -*- coding: utf-8 -*-
#
# ActiveRecord のレコードが Enumerable だと to_json が空になる現象
# to_xml だと問題ない
#
require "bundler/setup"

require "rails"
require "active_record"
require "tree_support"
require "byebug"

Class.new(Rails::Application){config.eager_load = false}.initialize! # Railtie を読ませるため

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
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

Node.create!(:name => "*root*")
Node.first.to_json              # => "[]"
Node.first.to_xml               # => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<node>\n  <id type=\"integer\">1</id>\n  <parent-id type=\"integer\" nil=\"true\"/>\n  <name>*root*</name>\n</node>\n"
