# output ../images/*
require "bundler/setup"
require "tree_support"

root = TreeSupport.example

p root.each_node.collect.with_index {|n, i| [n.name, i]}
puts root.to_s_tree
puts TreeSupport.tree(root)
puts TreeSupport.tree(root, drop: 1)
puts TreeSupport.tree(root, take: 3)
puts TreeSupport.tree(root, take: 3, drop: 1)
puts TreeSupport.tree(root) {|node, _locals| node.object_id}
# TreeSupport.graph_open(root)

TreeSupport.graphviz(root) {|node|
  if node.name.include?("Attack")
    {fillcolor: "lightblue", style: "filled"}
  elsif node.name.include?("Recover")
    {fillcolor: "lightpink", style: "filled"}
  end
}.output("../images/tree_color.png")

TreeSupport.graphviz(root) {|node|
  {label: node.name.chars.first}
}.output("../images/tree_label.png")

TreeSupport.graphviz(root).output("../images/tree.png")
TreeSupport.graphviz(root, take: 3).output("../images/take.png")
TreeSupport.graphviz(root, drop: 1).output("../images/drop.png")
TreeSupport.graphviz(root, take: 3, drop: 1).output("../images/take_drop.png")
# >> [["*root*", 0], ["Battle", 1], ["Attack", 2], ["Shake the sword", 3], ["Attack magic", 4], ["Summoner Monster A", 5], ["Summoner Monster B", 6], ["Repel sword in length", 7], ["Defense", 8], ["Withdraw", 9], ["To stop", 10], ["Place a trap", 11], ["Shoot a bow and arrow", 12], ["To escape", 13], ["Break", 14], ["Stop", 15], ["Recover", 16], ["Recovery magic", 17], ["Drink recovery medicine", 18]]
# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Shake the sword
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoner Monster A
# >> │   │   │   └─Summoner Monster B
# >> │   │   └─Repel sword in length
# >> │   └─Defense
# >> ├─Withdraw
# >> │   ├─To stop
# >> │   │   ├─Place a trap
# >> │   │   └─Shoot a bow and arrow
# >> │   └─To escape
# >> └─Break
# >>     ├─Stop
# >>     └─Recover
# >>         ├─Recovery magic
# >>         └─Drink recovery medicine
# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Shake the sword
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoner Monster A
# >> │   │   │   └─Summoner Monster B
# >> │   │   └─Repel sword in length
# >> │   └─Defense
# >> ├─Withdraw
# >> │   ├─To stop
# >> │   │   ├─Place a trap
# >> │   │   └─Shoot a bow and arrow
# >> │   └─To escape
# >> └─Break
# >>     ├─Stop
# >>     └─Recover
# >>         ├─Recovery magic
# >>         └─Drink recovery medicine
# >> Battle
# >> ├─Attack
# >> │   ├─Shake the sword
# >> │   ├─Attack magic
# >> │   │   ├─Summoner Monster A
# >> │   │   └─Summoner Monster B
# >> │   └─Repel sword in length
# >> └─Defense
# >> Withdraw
# >> ├─To stop
# >> │   ├─Place a trap
# >> │   └─Shoot a bow and arrow
# >> └─To escape
# >> Break
# >> ├─Stop
# >> └─Recover
# >>     ├─Recovery magic
# >>     └─Drink recovery medicine
# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   └─Defense
# >> ├─Withdraw
# >> │   ├─To stop
# >> │   └─To escape
# >> └─Break
# >>     ├─Stop
# >>     └─Recover
# >> Battle
# >> ├─Attack
# >> └─Defense
# >> Withdraw
# >> ├─To stop
# >> └─To escape
# >> Break
# >> ├─Stop
# >> └─Recover
# >> 70279213508120
# >> ├─70279213507760
# >> │   ├─70279213507500
# >> │   │   ├─70279213507240
# >> │   │   ├─70279213507000
# >> │   │   │   ├─70279213506800
# >> │   │   │   └─70279213506660
# >> │   │   └─70279213507200
# >> │   └─70279213509960
# >> ├─70279213498160
# >> │   ├─70279213497920
# >> │   │   ├─70279213497740
# >> │   │   └─70279213497600
# >> │   └─70279213497380
# >> └─70279213497180
# >>     ├─70279213496960
# >>     └─70279213496720
# >>         ├─70279213496480
# >>         └─70279213496320
