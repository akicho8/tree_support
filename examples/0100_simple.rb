require "bundler/setup"
require "tree_support"
puts TreeSupport.tree(TreeSupport.example)
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
