require "spec_helper"

RSpec.describe "Node" do
  before do
    @records = [
      {:key => :a0, :parent => nil},
      {:key => :a1, :parent => :a0},
      {:key => :a2, :parent => :a1},
      {:key => :b0, :parent => nil},
      {:key => :b1, :parent => :b0},
      {:key => :b2, :parent => :b1},
    ]
  end

  it "配列→木(複数)" do
    TreeSupport.records_to_tree(@records).collect(&:to_s_tree).join.should == <<-EOT
a0
└─a1
    └─a2
b0
└─b1
    └─b2
EOT

  end

  it "配列→木(一つ)" do
    TreeSupport.records_to_tree(@records, :root_key => :root).to_s_tree.should == <<-EOT
root
├─a0
│   └─a1
│       └─a2
└─b0
    └─b1
        └─b2
EOT
  end

  it "木→配列" do
    root = TreeSupport.records_to_tree(@records, :root_key => :root)
    records = TreeSupport.tree_to_records(root)
    records.should == [
      {:key => :root, :parent => nil   },
      {:key => :a0,   :parent => :root },
      {:key => :a1,   :parent => :a0   },
      {:key => :a2,   :parent => :a1   },
      {:key => :b0,   :parent => :root },
      {:key => :b1,   :parent => :b0   },
      {:key => :b2,   :parent => :b1   },
    ]
  end
end
