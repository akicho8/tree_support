# -*- coding: utf-8 -*-
#
# 画像変換
#
require "../lib/tree_support"
root = TreeSupport.example
TreeSupport.graphviz(root).save("_tree", :png)
