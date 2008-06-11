require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Node do
  before(:each) do
    @node = Node.new
  end

  it "should be valid" do
    @node.should be_valid
  end
end
