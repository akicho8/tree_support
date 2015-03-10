# # -*- coding: utf-8 -*-
# #
# # TreeSupport::ActsAsTree を使った例
# #
# require "bundler/setup"
# 
# require "rails"
# require "active_record"
# require "tree_support"
# require "byebug"
# 
# Class.new(Rails::Application){config.eager_load = false}.initialize! # Railtie を読ませるため
# 
# ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
# ActiveRecord::Migration.verbose = false
# 
# ActiveRecord::Schema.define do
#   create_table :nodes do |t|
#     t.belongs_to :parent
#     t.string :name
#   end
# end
# 
# class Node < ActiveRecord::Base
#   acts_as_tree scope: -> { order(:name).where.not(:name => "休憩") }
# 
#   def add(name, &block)
#     tap do
#       child = children.create!(:name => name)
#       if block_given?
#         child.instance_eval(&block)
#       end
#     end
#   end
# end
# 
# Node.create!(:name => "*root*").tap do |n|
#   n.instance_eval do
#     add "交戦" do
#     end
#   end
# end
# 
# # p Node.first.as_json
# r = Node.first
# p r.to_a.first.to_json
# # p ActiveRecord::Coders::JSON.dump(r)

