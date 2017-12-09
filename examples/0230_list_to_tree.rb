require "bundler/setup"
require "tree_support"

records = [
  {:key => :a0, :parent => nil},
  {:key => :a1, :parent => :a0},
  {:key => :a2, :parent => :a1},

  {:key => :b0, :parent => nil},
  {:key => :b1, :parent => :b0},
  {:key => :b2, :parent => :b1},
]

# ---------- Convert with function of library
if true
  puts TreeSupport.records_to_tree(records).collect(&:to_s_tree)
  puts TreeSupport.records_to_tree(records, :root_key => :root).to_s_tree
end

# ---------- How to write by yourself
if true
  source_hash = records.inject({}) { |a, e| a.merge(e[:key] => e) }
  node_hash = records.inject({}) { |a, e| a.merge(e[:key] => TreeSupport::Node.new(e[:key])) }
  node_hash.each_value { |node|
    if parent = source_hash[node.key][:parent]
      parent_node = node_hash[parent]
      node.parent = parent_node
      parent_node.children << node
    end
  }
  roots = node_hash.each_value.find_all {|e| e.parent == nil }
  puts roots.collect(&:to_s_tree)

  # When you want to make one route
  root = TreeSupport::Node.new(:root)
  roots.each do |e|
    e.parent = root
    root.children << e
  end
  puts root.to_s_tree
end

# >> a0
# >> └─a1
# >>     └─a2
# >> b0
# >> └─b1
# >>     └─b2
# >> root
# >> ├─a0
# >> │   └─a1
# >> │       └─a2
# >> └─b0
# >>     └─b1
# >>         └─b2
# >> a0
# >> └─a1
# >>     └─a2
# >> b0
# >> └─b1
# >>     └─b2
# >> root
# >> ├─a0
# >> │   └─a1
# >> │       └─a2
# >> └─b0
# >>     └─b1
# >>         └─b2
