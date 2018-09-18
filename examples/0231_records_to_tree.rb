require "bundler/setup"
require "tree_support"

# Methods for easily making trees from data like CSV
# Array -> Tree

records = [
  {key: :a, parent: nil},
  {key: :b, parent: :a},
  {key: :c, parent: :b},
]

# When the first node is regarded as a parent
puts TreeSupport.records_to_tree(records).first.to_s_tree

# When you make a parent parenting the whole
puts TreeSupport.records_to_tree(records, root_key: :root).to_s_tree

# Convert from tree to array
tree = TreeSupport.records_to_tree(records)
pp TreeSupport.tree_to_records(tree.first)

# >> a
# >> └─b
# >>     └─c
# >> root
# >> └─a
# >>     └─b
# >>         └─c
# >> [{:key=>:a, :parent=>nil}, {:key=>:b, :parent=>:a}, {:key=>:c, :parent=>:b}]
