# Image conversion
#
require "bundler/setup"
require "tree_support"
root = TreeSupport.example
TreeSupport.graphviz(root).output("_tree.png")
