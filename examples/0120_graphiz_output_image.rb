# -*- coding: utf-8 -*-
#
# 画像変換
#
require "bundler/setup"
require "tree_support"
root = TreeSupport.example
TreeSupport.graphviz(root).output("_tree.png")
