# each_node can be used if Treeable module is included
#
require "bundler/setup"
require "tree_support"

root = TreeSupport.example
root.class.ancestors                  # => [TreeSupport::Node, TreeSupport::Stringify, TreeSupport::Treeable, Object, Kernel, BasicObject]
root.each_node.with_index {|n, i| p [i, n.name] }

# >> [0, "*root*"]
# >> [1, "Battle"]
# >> [2, "Attack"]
# >> [3, "Shake the sword"]
# >> [4, "Attack magic"]
# >> [5, "Summoner Monster A"]
# >> [6, "Summoner Monster B"]
# >> [7, "Repel sword in length"]
# >> [8, "Defense"]
# >> [9, "Withdraw"]
# >> [10, "To stop"]
# >> [11, "Place a trap"]
# >> [12, "Shoot a bow and arrow"]
# >> [13, "To escape"]
# >> [14, "Break"]
# >> [15, "Stop"]
# >> [16, "Recover"]
# >> [17, "Recovery magic"]
# >> [18, "Drink recovery medicine"]
