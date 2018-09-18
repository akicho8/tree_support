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
# >> [["*root*", 0], ["Battle", 1], ["Attack", 2], ["Shake the sword", 3], ["Attack magic", 4], ["Summoned Beast X", 5], ["Summoned Beast Y", 6], ["Repel sword in length", 7], ["Defense", 8], ["Withdraw", 9], ["To stop", 10], ["Place a trap", 11], ["Shoot a bow and arrow", 12], ["To escape", 13], ["Break", 14], ["Stop", 15], ["Recover", 16], ["Recovery magic", 17], ["Drink recovery medicine", 18]]
# >> *root*
# >> ├─Battle
# >> │   ├─Attack
# >> │   │   ├─Shake the sword
# >> │   │   ├─Attack magic
# >> │   │   │   ├─Summoned Beast X
# >> │   │   │   └─Summoned Beast Y
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
# >> │   │   │   ├─Summoned Beast X
# >> │   │   │   └─Summoned Beast Y
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
# >> │   │   ├─Summoned Beast X
# >> │   │   └─Summoned Beast Y
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
# >> 70308246324740
# >> ├─70308246324580
# >> │   ├─70308246324440
# >> │   │   ├─70308246324300
# >> │   │   ├─70308246324200
# >> │   │   │   ├─70308246324060
# >> │   │   │   └─70308246323960
# >> │   │   └─70308246323860
# >> │   └─70308246323760
# >> ├─70308246323660
# >> │   ├─70308246323520
# >> │   │   ├─70308246323380
# >> │   │   └─70308246323280
# >> │   └─70308246314940
# >> └─70308246314840
# >>     ├─70308246314700
# >>     └─70308246314600
# >>         ├─70308246314460
# >>         └─70308246314360
