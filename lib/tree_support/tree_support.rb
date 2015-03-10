# -*- coding: utf-8 -*-
# 木構造可視化ライブラリ
#
#   root = TreeSupport::Node.new("ROOT") do
#     add "A" do
#       add "B" do
#         add "C"
#       end
#     end
#   end
#
#   puts TreeSupport.tree(root)
#   > ROOT
#   > └─A
#   >     └─B
#   >         └─C

require "tree_support/treeable"
require "tree_support/inspector"
require "tree_support/node"
require "tree_support/acts_as_tree" if defined?(ActiveRecord)
require "tree_support/railtie" if defined?(Rails)

# gviz は Object を触るため使わないときは入れないようにする
begin
  require "gviz"
  require "tree_support/graphviz_builder"
rescue LoadError
end
