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

require "tree_support/version"
require "tree_support/treeable"
require "tree_support/inspector"
require "tree_support/graphviz_builder"
require "tree_support/node"

if defined?(Rails)
  require "tree_support/acts_as_tree"
  require "tree_support/railtie"
end
