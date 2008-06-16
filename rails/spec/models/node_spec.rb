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
    it 'should allow specifying a timestamp'    

    describe 'when a timestamp is specified' do
      it 'should look up the most recent Facts for the Node before the specified timestamp'
      it 'should return the looked up Facts'
    end

    describe 'when no timestamp is provided' do
      it 'should look up the most recent Facts for the Node'    
      it 'should return the looked up Facts'    
    end
    
    describe '(put this somewhere) when no Facts are available' do
      it 'should call Facter to find the most recent Facts for the Node'
    end    
  end
end
