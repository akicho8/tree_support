# -*- coding: utf-8 -*-
require "bundler/setup"
require "tree_support"
puts "--------------------------------------------------------------------------------"
puts TreeSupport.example.to_s_tree(drop: 3)
puts "--------------------------------------------------------------------------------"
puts TreeSupport.example.to_s_tree(take: 3)
puts "--------------------------------------------------------------------------------"
puts TreeSupport.example.to_s_tree(take: 3, drop: 1)
# >> --------------------------------------------------------------------------------
# >> Shake the sword
# >> Attack magic
# >> ├─Summoner Monster A
# >> └─Summoner Monster B
# >> Repel sword in length
# >> Place a trap
# >> Shoot a bow and arrow
# >> Recovery magic
# >> Drink recovery medicine
# >> --------------------------------------------------------------------------------
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
# >> --------------------------------------------------------------------------------
# >> Battle
# >> ├─Attack
# >> └─Defense
# >> Withdraw
# >> ├─To stop
# >> └─To escape
# >> Break
# >> ├─Stop
# >> └─Recover
