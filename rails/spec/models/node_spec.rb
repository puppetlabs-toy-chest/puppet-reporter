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
    
    it 'can have failures' do
      @node.should respond_to(:failures)
    end
    
    it 'should get failures through its reports' do
      @node = Node.generate!
      2.times do |i|
        rep = @node.reports.generate!(:timestamp => Time.zone.now + i)
        3.times do |j|
          rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 5.0 * (i+1))
        end
      end
      @node.reload
      
      failures = @node.reports.collect(&:failures).flatten
      @node.failures.sort_by(&:id).should == failures.sort_by(&:id)
    end
    
    it 'should order failures by report timestamp, most recent first' do
      @node = Node.generate!
      failures = []
      rep = @node.reports.generate!(:timestamp => Time.zone.now + 5)
      failures.push rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 5.0)
      rep = @node.reports.generate!(:timestamp => Time.zone.now - 5)
      failures.push rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 5.0)
      rep = @node.reports.generate!(:timestamp => Time.zone.now + 20)
      failures.unshift rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 5.0)
      @node.reload
      
      @node.failures.should == failures
    end
    
    it 'should have an option to include failures with a value of 0' do
      @node = Node.generate!
      rep = nil
      2.times do |i|
        rep = @node.reports.generate!(:timestamp => Time.zone.now + i)
        3.times do |j|
          rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 5.0 * (i+1))
        end
      end
      failure = rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 0)
      @node.reload
      
      @node.failures(true).should include(failure)
    end
    
    it 'should not include failures with a value of 0 if given a false value' do
      @node = Node.generate!
      rep = nil
      2.times do |i|
        rep = @node.reports.generate!(:timestamp => Time.zone.now + i)
        3.times do |j|
          rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 5.0 * (i+1))
        end
      end
      failure = rep.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 0)
      @node.reload
      
      @node.failures(false).should_not include(failure)
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
        @node.details(Time.zone.now).should == @fact.values.values
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
        @node.details.should == @fact.values.values
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
    
    it 'should return Facts on the time specified' do
      @node.most_recent_facts_on(@time).values[:name].should == 'now'
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
    
    it 'should return a report on the time specified' do
      @node.most_recent_report_on(@time).details.should == 'now'
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

  describe 'as a class' do
    it 'should get failed nodes' do
      Node.should respond_to(:failed)
    end
    
    describe 'getting failed nodes' do
      before :each do
        @failed_node     = Node.generate!
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 3, :report => Report.generate!(:node => @failed_node, :timestamp => Time.zone.now - 15))
        
        @okay_node       = Node.generate!
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 0, :report => Report.generate!(:node => @okay_node))
        
        @great_node      = Node.generate!
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 0, :report => Report.generate!(:node => @great_node, :timestamp => Time.zone.now - 25))
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 0, :report => Report.generate!(:node => @great_node, :timestamp => Time.zone.now - 57))
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 0, :report => Report.generate!(:node => @great_node, :timestamp => Time.zone.now - 500))
        
        @bigfail_node    = Node.generate!
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 35, :report => Report.generate!(:node => @bigfail_node, :timestamp => Time.zone.now - 5))
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 32, :report => Report.generate!(:node => @bigfail_node, :timestamp => Time.zone.now - 30))
        
        @fixed_node      = Node.generate!
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 0, :report => Report.generate!(:node => @fixed_node, :timestamp => Time.zone.now - 5))
        Metric.generate!(:category => 'resources', :label => 'Failed', :value => 3, :report => Report.generate!(:node => @fixed_node, :timestamp => Time.zone.now - 15))
        
        @reportless_node = Node.generate!
      end
      
      it 'should return nodes which have failures in the most recent report' do
        failed = Node.failed
        [@failed_node, @bigfail_node].each do |node|
          failed.should include(node)
        end
      end
      
      it 'should not return nodes which have no failures in any reports' do
        failed = Node.failed
        [@okay_node, @great_node].each do |node|
          failed.should_not include(node)
        end
      end
      
      it 'should not return nodes which have no reports' do
        Node.failed.should_not include(@reportless_node)
      end
      
      it 'should not return nodes which have no failures in the most recent report' do
        Node.failed.should_not include(@fixed_node)
      end
      
      it 'should return the empty list if there are no matching nodes' do
        [@failed_node, @bigfail_node].each(&:destroy)
        Node.failed.should == []
      end
      
      it 'should return the empty list if there are no nodes' do
        Node.delete_all
        Node.failed.should == []
      end
    end
    
    it 'should get silent nodes' do
      Node.should respond_to(:silent)
    end
    
    describe 'getting silent nodes' do
      before :each do
        Node.delete_all
        
        @recent_node     = Node.generate!
        @recent_node.reports.generate!(:timestamp => Time.zone.now - 5)
        
        @now_node        = Node.generate!
        @now_node.reports.generate!(:timestamp => Time.zone.now)
        
        @while_ago_node  = Node.generate!
        @while_ago_node.reports.generate!(:timestamp => Time.zone.now - 29.5.minutes)
        
        @talky_node      = Node.generate!
        @talky_node.reports.generate!(:timestamp => Time.zone.now - 10)
        @talky_node.reports.generate!(:timestamp => Time.zone.now - 50)
        @talky_node.reports.generate!(:timestamp => Time.zone.now - 10.minutes)
        @talky_node.reports.generate!(:timestamp => Time.zone.now - 20.minutes)
        @talky_node.reports.generate!(:timestamp => Time.zone.now - 40.minutes)
        
        @long_ago_node    = Node.generate!
        @long_ago_node.reports.generate!(:timestamp => Time.zone.now - 40.minutes)
        
        @reportless_node = Node.generate!
      end
      
      it 'should return nodes with no reports in the past 30 minutes' do
        silent = Node.silent
          [@long_ago_node].each do |node|
          silent.should include(node)
        end
      end
      
      it 'should not return nodes with reports in the past 30 minutes' do
        silent = Node.silent
          [@recent_node, @now_node, @while_ago_node, @talky_node].each do |node|
          silent.should_not include(node)
        end
      end
      
      it 'should return nodes with have no reports' do
        Node.silent.should include(@reportless_node)
      end
      
      it 'should return the empty list if there are no matching nodes' do
        [@long_ago_node, @reportless_node].each(&:destroy)
        Node.silent.should == []
      end
      
      it 'should return the empty list if there are no nodes' do
        Node.delete_all
        Node.silent.should == []
      end
    end
  end
end
