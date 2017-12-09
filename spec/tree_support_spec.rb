require "spec_helper"

RSpec.describe "TreeSupport" do
  it "tree" do
    expected = <<-EOT
*root*
├─Battle
│   ├─Attack
│   │   ├─Shake the sword
│   │   ├─Attack magic
│   │   │   ├─Summoned Beast X
│   │   │   └─Summoned Beast Y
│   │   └─Repel sword in length
│   └─Defense
├─Withdraw
│   ├─To stop
│   │   ├─Place a trap
│   │   └─Shoot a bow and arrow
│   └─To escape
└─Break
    ├─Stop
    └─Recover
        ├─Recovery magic
        └─Drink recovery medicine
EOT
    TreeSupport.example.to_s_tree.should == expected
  end
end
