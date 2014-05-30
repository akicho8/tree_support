# -*- coding: utf-8 -*-
#
# 画像変換
#
$LOAD_PATH.unshift("../lib")
require "tree_support"
root = TreeSupport.example
TreeSupport.graphviz(root).output("_tree.png")
