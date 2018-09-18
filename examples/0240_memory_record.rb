# Example of combining with MemoryRecord
require "bundler/setup"
require "tree_support"
require "memory_record"

class TreeModel
  include MemoryRecord
  memory_record [
    {key: :a, name: "A", parent: nil},
    {key: :b, name: "B", parent: :a},
    {key: :c, name: "C", parent: :b},
  ]

  # Any structure can be used as long as it can respond to parent and children
  concerning :TreeMethods do
    included do
      include TreeSupport::Treeable
      include TreeSupport::Stringify
    end

    def parent
      self.class[super]
    end

    def children
      self.class.find_all {|e| e.parent == self }
    end
  end
end

puts TreeModel.find_all(&:root?).collect(&:to_s_tree)
# >> A
# >> └─B
# >>     └─C
