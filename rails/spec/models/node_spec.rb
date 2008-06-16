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
    it 'should allow specifying a timestamp' do
      lambda { @node.details(Time.now) }.should_not raise_error
    end

    describe 'when a timestamp is specified' do
      it 'should look up the most recent Facts for the Node before the specified timestamp' do
        @time = Time.now
        @node.expects(:most_recent_facts_on).with(@time)
        @node.details(@time)
      end
      
      it 'should return the looked up Facts' do
        @node.stubs(:most_recent_facts_on).returns('result')
        @node.details(Time.now).should == 'result'
      end
    end

    describe 'when no timestamp is provided' do
      it 'should look up the most recent Facts for the Node' do
        @time = Time.now
        Time.stubs(:now).returns(@time)
        @node.expects(:most_recent_facts_on).with(@time)
        @node.details
      end
      
      it 'should return the looked up Facts' do
        @node.stubs(:most_recent_facts_on).returns('result')
        @node.details.should == 'result'        
      end
    end

    describe '(put this somewhere) when no Facts are available' do
      it 'should call Facter to find the most recent Facts for the Node'
    end    
  end
end
