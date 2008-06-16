require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Node do
  before(:each) do
    @node = Node.new(:name => 'foo')
  end

  it "should be valid" do
    @node.should be_valid
  end
  
  describe 'to_param' do
    it 'should return the node name' do
      @node.to_param.should == 'foo'
    end
  end
  
  describe 'attributes' do
    before :each do
      @node = Node.new
    end
    
    it 'should have a name' do
      @node.name.should be_nil
    end
  end

  
  describe 'details' do
    it 'should be a hash' do
      @node.details.should == {}
    end
  end
end
