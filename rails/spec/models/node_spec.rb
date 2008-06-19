require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Node do
  before(:each) do
    @node = Node.new(:name => 'foo')
  end

  describe 'when validating' do
    before :each do
      @params = { :name => 'foo' }
    end
    
    it 'should not be valid without a name' do
      @node = Node.new(@params.merge(:name => nil))
      @node.should_not be_valid
      @node.should have(1).errors_on(:name)
    end
    
    it "should be valid with a name" do
      Node.new(@params).should be_valid
    end
    
    it 'should require names to be unique' do
      Node.generate(:name => 'foo')
      @node = Node.new(:name => 'foo')
      @node.should_not be_valid
      @node.should have(1).errors_on(:name)
    end
  end
  
  describe 'to_param' do
    it 'should return the node name' do
      @node.to_param.should == 'foo'
    end
  end
  
  describe 'associations' do
    it 'can have facts' do
      @node.facts.should == []
    end
    
    it 'can have reports' do
      @node.reports.should == []
    end
    
    it 'can have logs' do
      @node.logs.should == []
    end
    
    it 'should get logs through its reports' do
      @node = Node.generate!
      2.times do |i|
        rep = @node.reports.generate!(:timestamp => Time.zone.now + i)
        3.times { rep.logs.generate! }
      end
      @node.reload
      
      logs = @node.reports.collect(&:logs).flatten
      @node.logs.sort_by(&:id).should == logs.sort_by(&:id)
    end
    
    it 'can have metrics' do
      @node.metrics.should == []
    end
    
    it 'should get metrics through its reports' do
      @node = Node.generate!
      2.times do |i|
        rep = @node.reports.generate!(:timestamp => Time.zone.now + i)
        3.times { rep.metrics.generate! }
      end
      @node.reload
      
      metrics = @node.reports.collect(&:metrics).flatten
      @node.metrics.sort_by(&:id).should == metrics.sort_by(&:id)
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
    before :each do
      @fact = Fact.new(:values => {'foo' => 'bar'})
      @node.stubs(:most_recent_facts_on).returns(@fact)
    end
    
    it 'should allow specifying a timestamp' do
      lambda { @node.details(Time.zone.now) }.should_not raise_error
    end

    describe 'when a timestamp is specified' do
      it 'should look up the most recent Facts for the Node before the specified timestamp' do
        @time = Time.zone.now
        @node.expects(:most_recent_facts_on).with(@time)
        @node.details(@time)
      end
      
      it 'should return the hash of values from the looked up Facts' do
        @node.details(Time.zone.now).should == @fact.values
      end
      
      describe 'when there are no facts to be found' do
        it 'should return a hash' do          
          @node.stubs(:most_recent_facts_on).returns(nil)
          @node.details(Time.zone.now).should == {}
        end
      end
    end

    describe 'when no timestamp is provided' do      
      it 'should look up the most recent Facts for the Node' do
        @time = Time.zone.now
        @timezone = stub('time zone', :now => @time)
        Time.stubs(:zone).returns(@timezone)
        @node.expects(:most_recent_facts_on).with(@time)
        @node.details
      end
      
      it 'should return the hash of values from the looked up Facts' do
        @node.details.should == @fact.values
      end
      
      describe 'when there are no facts to be found' do
        it 'should return a hash' do          
          @node.stubs(:most_recent_facts_on).returns(nil)
          @node.details.should == {}
        end
      end
    end
  end
  
  describe 'when looking up most recent facts' do
    before :each do
      @node = Node.generate
      @time = Time.zone.now
      @facts = [ Fact.generate(:values => {:name => 'old'}, :timestamp => 2.days.ago), 
                 Fact.generate(:values => {:name => 'now'}, :timestamp => @time), 
                 Fact.generate(:values => {:name => 'new'}, :timestamp => 2.days.from_now)]
      @node.facts << @facts
    end
    
    it 'should require a timestamp' do
      lambda { @node.most_recent_facts_on }.should raise_error(ArgumentError)
    end
    
    it 'should return the most recent Facts for this Node at the time specified' do
      @node.most_recent_facts_on(1.hour.from_now(@time)).values[:name].should == 'now'
    end
    
    it 'should return nil if there are no facts at the time specified' do
      @node.most_recent_facts_on(3.days.ago(@time)).should be_nil
    end
    
    it 'should return nil if there are no facts at all for the node' do
      Node.generate.most_recent_facts_on(Time.zone.now).should be_nil
    end
  end
  
  describe 'when looking up most recent reports' do
    before :each do
      @node = Node.generate
      @time = Time.zone.now
      @node.reports.generate(:details => 'old', :timestamp => 2.days.ago)
      @node.reports.generate(:details => 'now', :timestamp => @time)
      @node.reports.generate(:details => 'new', :timestamp => 2.days.from_now)
    end
    
    it 'should require a timestamp' do
      lambda { @node.most_recent_report_on }.should raise_error(ArgumentError)
    end
    
    it 'should return the most recent report for this Node at the time specified' do
      @node.most_recent_report_on(1.hour.from_now(@time)).details.should == 'now'
    end
    
    it 'should return nil if there are no reports at the time specified' do
      @node.most_recent_report_on(3.days.ago(@time)).should be_nil
    end
    
    it 'should return nil if there are no reports at all for the node' do
      Node.generate.most_recent_report_on(Time.zone.now).should be_nil
    end
  end
  
  describe 'refresh Facts from source' do
    before :each do
      @node = Node.generate
      @fact = Fact.generate
    end
    
    it 'should take no arguments' do
      lambda { @node.refresh_facts('something') }.should raise_error(ArgumentError)
    end
    
    it 'should ask for facts to be refreshed' do
      Fact.expects(:refresh_for_node).with(@node).returns(@fact)
      @node.refresh_facts
    end
    
    describe 'if fact refresh fails' do
      before :each do
        Fact.stubs(:refresh_for_node).raises(RuntimeError)
      end
      
      it 'should not update the facts for the node' do
        lambda { @node.refresh_facts }
        @node.reload.facts.should be_empty
      end
      
      it 'should raise an error' do
        lambda { @node.refresh_facts }.should raise_error
      end
    end
    
    describe 'if fact refresh succeeds' do
      before :each do
        Fact.stubs(:refresh_for_node).returns(@fact)
      end
      
      it 'should save the facts as the most recent facts for the node' do
        @node.refresh_facts
        @node.reload.facts.first.should == @fact
      end
      
      it 'should return the facts' do
        @node.refresh_facts.should == @fact
      end
    end
  end
end
