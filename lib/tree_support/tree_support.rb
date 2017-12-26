# Tree structure visualization library
#
#   root = TreeSupport::Node.new("ROOT") do
#     add "A" do
#       add "B" do
#         add "C"
#       end
#     end
#   end
#
#   puts TreeSupport.tree(root)
#   > ROOT
#   > └─A
#   >     └─B
#   >         └─C

require "tree_support/treeable"
require "tree_support/inspector"
require "tree_support/node"
require "tree_support/ar_tree_model" if defined?(ActiveRecord) || defined?(Rails)
require "tree_support/railtie" if defined?(Rails)

# Do not put gviz when you do not use it to touch Object
begin
  require "gviz"
  require "tree_support/graphviz_builder"
rescue LoadError
end
