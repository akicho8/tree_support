# Generating original code from tree of TreeSupport::Node Rough

require "bundler/setup"
require "tree_support"

def generate(node)
  s = ""
  if node.parent
    s << "add #{node.name.inspect}"
  else
    s << "TreeSupport::Node.new(#{node.name.inspect})"
  end
  unless node.children.empty?
    s << [" do\n", node.children.collect {|node| generate(node) }.join, "end"].join
  end
  s << "\n"
end

code = generate(TreeSupport.example)
puts code

puts TreeSupport.tree(eval(code))
# >> TreeSupport::Node.new("*root*") do
# >> add "Battle" do
# >> add "Attack" do
# >> add "Shake the sword"
# >> add "Attack magic" do
# >> add "Summoner Monster A"
# >> add "Summoner Monster B"
# >> end
# >> add "Repel sword in length"
# >> end
# >> add "Defense"
# >> end
# >> add "Withdraw" do
# >> add "To stop" do
# >> add "Place a trap"
# >> add "Shoot a bow and arrow"
# >> end
# >> add "To escape"
# >> end
# >> add "Break" do
# >> add "Stop"
# >> add "Recover" do
# >> add "Recovery magic"
# >> add "Drink recovery medicine"
# >> end
# >> end
# >> end
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
