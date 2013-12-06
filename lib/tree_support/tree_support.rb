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

if $0 == __FILE__
  root = TreeSupport.example
  p root.each_node.collect.with_index{|n, i|[n.name, i]}

  puts root.tree
  puts TreeSupport.tree(root)

  puts TreeSupport.tree(root, :drop => 1)

  puts TreeSupport.tree(root){|node, locals|node.object_id}

  gv = TreeSupport.graphviz(root)
  puts gv.to_dot
  gv.output("_output1.png")

  gv = TreeSupport.graphviz(root){|node|
    if node.name.include?("攻")
      {:fillcolor => "lightblue", :style => "filled"}
    elsif node.name.include?("回復")
      {:fillcolor => "lightpink", :style => "filled"}
    end
  }
  gv.output("_output2.png")

  gv = TreeSupport.graphviz(root){|node|
    {:label => node.name.chars.first}
  }
  gv.output("_output3.png")

  TreeSupport.graph_open(root)

  gv = TreeSupport.graphviz(root, :drop => 1)
  gv.output("_output4.png")
end
