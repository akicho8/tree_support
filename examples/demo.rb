# -*- coding: utf-8 -*-
# ../images/* の出力
require "bundler/setup"
require "tree_support"

root = TreeSupport.example

p root.each_node.collect.with_index{|n, i|[n.name, i]}
puts root.to_s_tree
puts TreeSupport.tree(root)
puts TreeSupport.tree(root, :drop => 1)
puts TreeSupport.tree(root, :take => 3)
puts TreeSupport.tree(root, :take => 3, :drop => 1)
puts TreeSupport.tree(root) {|node, _locals|node.object_id}
# TreeSupport.graph_open(root)

TreeSupport.graphviz(root) {|node|
  if node.name.include?("攻")
    {:fillcolor => "lightblue", :style => "filled"}
  elsif node.name.include?("回復")
    {:fillcolor => "lightpink", :style => "filled"}
  end
}.output("../images/tree_color.png")

TreeSupport.graphviz(root) {|node|
  {:label => node.name.chars.first}
}.output("../images/tree_label.png")

TreeSupport.graphviz(root).output("../images/tree.png")
TreeSupport.graphviz(root, :take => 3).output("../images/take.png")
TreeSupport.graphviz(root, :drop => 1).output("../images/drop.png")
TreeSupport.graphviz(root, :take => 3, :drop => 1).output("../images/take_drop.png")
# >> [["*root*", 0], ["交戦", 1], ["攻撃", 2], ["剣を振る", 3], ["攻撃魔法", 4], ["召喚A", 5], ["召喚B", 6], ["縦で剣をはじく", 7], ["防御", 8], ["撤退", 9], ["足止めする", 10], ["トラップをしかける", 11], ["弓矢を放つ", 12], ["逃走する", 13], ["休憩", 14], ["立ち止まる", 15], ["回復する", 16], ["回復魔法", 17], ["回復薬を飲む", 18]]
# >> *root*
# >> ├─交戦
# >> │   ├─攻撃
# >> │   │   ├─剣を振る
# >> │   │   ├─攻撃魔法
# >> │   │   │   ├─召喚A
# >> │   │   │   └─召喚B
# >> │   │   └─縦で剣をはじく
# >> │   └─防御
# >> ├─撤退
# >> │   ├─足止めする
# >> │   │   ├─トラップをしかける
# >> │   │   └─弓矢を放つ
# >> │   └─逃走する
# >> └─休憩
# >>     ├─立ち止まる
# >>     └─回復する
# >>         ├─回復魔法
# >>         └─回復薬を飲む
# >> *root*
# >> ├─交戦
# >> │   ├─攻撃
# >> │   │   ├─剣を振る
# >> │   │   ├─攻撃魔法
# >> │   │   │   ├─召喚A
# >> │   │   │   └─召喚B
# >> │   │   └─縦で剣をはじく
# >> │   └─防御
# >> ├─撤退
# >> │   ├─足止めする
# >> │   │   ├─トラップをしかける
# >> │   │   └─弓矢を放つ
# >> │   └─逃走する
# >> └─休憩
# >>     ├─立ち止まる
# >>     └─回復する
# >>         ├─回復魔法
# >>         └─回復薬を飲む
# >> 交戦
# >> ├─攻撃
# >> │   ├─剣を振る
# >> │   ├─攻撃魔法
# >> │   │   ├─召喚A
# >> │   │   └─召喚B
# >> │   └─縦で剣をはじく
# >> └─防御
# >> 撤退
# >> ├─足止めする
# >> │   ├─トラップをしかける
# >> │   └─弓矢を放つ
# >> └─逃走する
# >> 休憩
# >> ├─立ち止まる
# >> └─回復する
# >>     ├─回復魔法
# >>     └─回復薬を飲む
# >> *root*
# >> ├─交戦
# >> │   ├─攻撃
# >> │   └─防御
# >> ├─撤退
# >> │   ├─足止めする
# >> │   └─逃走する
# >> └─休憩
# >>     ├─立ち止まる
# >>     └─回復する
# >> 交戦
# >> ├─攻撃
# >> └─防御
# >> 撤退
# >> ├─足止めする
# >> └─逃走する
# >> 休憩
# >> ├─立ち止まる
# >> └─回復する
# >> 70330517629360
# >> ├─70330517617140
# >> │   ├─70330517612220
# >> │   │   ├─70330517615180
# >> │   │   ├─70330517618480
# >> │   │   │   ├─70330517596160
# >> │   │   │   └─70330517597180
# >> │   │   └─70330517598460
# >> │   └─70330517599600
# >> ├─70330517601020
# >> │   ├─70330517579960
# >> │   │   ├─70330517579780
# >> │   │   └─70330517581940
# >> │   └─70330517583780
# >> └─70330517585860
# >>     ├─70330517563860
# >>     └─70330517566840
# >>         ├─70330517549180
# >>         └─70330517547400
