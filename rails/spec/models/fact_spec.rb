require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fact do
  before(:each) do
    @fact = Fact.new
  end

  it "should be valid" do
    @fact.should be_valid
  end
  
  describe 'associations' do
    it 'should have a node' do
      @fact.node.should be_nil
    end  
  end
  
  describe 'attributes' do
    it 'should have values' do
      @fact.values.should be_nil
    end
    
    it 'should have a timestamp' do
      @fact.timestamp.should be_nil
    end
  end

  describe 'values' do
    before :each do
      @fact = Fact.spawn
    end
    
    it 'should be able to store a hash' do
      @fact.values = { :foo => 'bar' }
      @fact.save
      @fact.values.should == { :foo => 'bar' }
    end
    
    it 'should keep the hash of values data' do
      @fact.values = { :foo => 'bar' }
      @fact.save
      @fact.reload.values.should == { :foo => 'bar' }
    end
  end
end
