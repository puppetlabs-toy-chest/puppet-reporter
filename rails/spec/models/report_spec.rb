require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Report do
  before :each do
    @yaml = report_yaml
    
  end
  
  before :each do
    @report = Report.new
  end

  describe 'when validating' do
    before :each do
      @report = Report.generate!
    end
    
    it "should not be valid without details" do
      @report.details = nil
      @report.should_not be_valid
      @report.should have(1).errors_on(:details)
    end
    
    it 'should be valid with details' do
      @report.details = { :foo => :bar }
      @report.should be_valid
    end
    
    it 'should error on node if no node given' do
      @report.node = nil
      @report.should_not be_valid
      @report.errors.should be_invalid(:node)
    end
    
    it 'should not error on node if node given' do
      @report.node = Node.new
      @report.should be_valid
    end
    
    it 'should error on timestamp if no timestamp given' do
      @report.timestamp = nil
      @report.should_not be_valid
      @report.errors.should be_invalid(:timestamp)
    end
    
    it 'should error on timestamp if no timestamp given' do
      @report.timestamp = Time.zone.now
      @report.should be_valid
    end
    
    it 'should not allow two reports with the same node and timestamp' do
      other_report = Report.generate(:node => @report.node, :timestamp => @report.timestamp)
      other_report.should_not be_valid
    end
    
    it 'should allow two reports with the same node and different timestamps' do
      other_report = Report.generate(:node => @report.node, :timestamp => @report.timestamp - 1)
      other_report.should be_valid
    end
    
    it 'should allow two reports with different nodes and the same timestamp' do
      other_report = Report.generate(:node => Node.generate!, :timestamp => @report.timestamp)
      other_report.should be_valid
    end
    
    it 'should allow two reports with different nodes and different timestamps' do
      other_report = Report.generate(:node => Node.generate!, :timestamp => @report.timestamp - 1)
      other_report.should be_valid
    end
  end
  
  describe 'associations' do
    it 'can have a node' do
      @report.node.should be_nil
    end
    
    it 'can have many logs' do
      @report.logs.should == []
    end

    it 'can have metrics' do
      @report.metrics.should == []
    end
    
    it 'can have failures' do
      @report.should respond_to(:failures)
    end
    
    it 'should get failures from its metrics' do
      failures = stub('failures')
      @report.metrics.stubs(:failures).returns(failures)
      @report.failures.should == failures
    end
    
    it 'should pass on arguments when getting failures' do
      arg = stub('arg')
      @report.metrics.expects(:failures).with(arg)
      @report.failures(arg)
    end
  end
  
  describe 'when creating' do
    before :each do
      @node = Node.generate!
    end
    
    it 'should freshen the facts for its associated node' do
      @node.expects(:refresh_facts)
      Report.generate!(:node => @node)
    end
    
    it 'should not raise an error if refreshing facts fails' do
      @node.stubs(:refresh_facts).raises(Exception)
      lambda { Report.generate!(:node => @node) }.should_not raise_error
    end
  end
  
  describe 'as a class' do
    describe 'loading report data from YAML files' do
      before :each do
        Report.stubs(:warn)
        
        @files = [ '/tmp/1', '/tmp/2', '/tmp/3' ]
        @report = Report.new
        @files.each do |file| 
          File.stubs(:read).with(file).returns("#{file} contents")
          Report.stubs(:from_yaml).with("#{file} contents").returns(@report)
        end
      end
      
      it 'should require at least one file name' do
        lambda { Report.import_from_yaml_files }.should raise_error(ArgumentError)
      end
      
      it 'should read each file' do
        @files.each {|file| File.expects(:read).with(file).returns("#{file} contents") }
        Report.import_from_yaml_files(@files)
      end
      
      it 'should create a report from the contents of each file' do
        @files.each do |file| 
          File.stubs(:read).with(file).returns("#{file} contents")
          Report.expects(:from_yaml).with("#{file} contents")
        end
        Report.import_from_yaml_files(@files)
      end
      
      describe 'if a file cannot be read' do
        before :each do
          File.stubs(:read).with(@files[1]).raises(Errno::ENOENT)          
        end
        
        it 'should not fail' do
          lambda { Report.import_from_yaml_files(@files) }.should_not raise_error               
        end
        
        it 'should emit a warning about the file' do
          Report.expects(:warn)
          Report.import_from_yaml_files(@files)
        end
        
        it 'should continue to process other files' do
          Report.expects(:from_yaml).with("#{@files.last} contents")
          Report.import_from_yaml_files(@files)
        end
      end
      
      describe 'if a report cannot be created from the contents of a file' do        
        before :each do
          Report.stubs(:from_yaml).with("#{@files[1]} contents").raises(RuntimeError)
        end

        it 'should not fail' do
          lambda { Report.import_from_yaml_files(@files) }.should_not raise_error               
        end        
        
        it 'should emit a warning about the file' do
          Report.expects(:warn)
          Report.import_from_yaml_files(@files)
        end
        
        it 'should continue to process other files' do
          Report.expects(:from_yaml).with("#{@files.last} contents")
          Report.import_from_yaml_files(@files)
        end
      end
      
      it 'should return a list of the files which had reports successfully created' do
        File.stubs(:read).with(@files[1]).raises(Errno::ENOENT)          
        Report.import_from_yaml_files(@files).first.should == [ @files.first, @files.last ]
      end
      
      it 'should return a list of the files which did not have reports successfully created' do
        File.stubs(:read).with(@files[1]).raises(Errno::ENOENT)          
        Report.import_from_yaml_files(@files).last.should == [ @files[1] ]
      end
    end
    
    describe 'creating reports from YAML' do
      before :each do
        @thawed = YAML.load(@yaml)
        @node = Node.generate
        @report = Report.generate
        Node.stubs(:find_by_name).returns(@node)
      end
      
      it 'should require a string of data' do
        lambda { Report.from_yaml }.should raise_error(ArgumentError)
      end
      
      it 'should reinstantiate a puppet report from the YAML string' do
        YAML.expects(:load).at_least_once.with(@yaml).returns(@thawed)  # NOTE: at_least_once because serializing details calls YAML.load internally, may point to refactoring
        Report.from_yaml(@yaml)
      end
      
      describe 'if a puppet report cannot be reinstantiated from the YAML string' do
        before :each do
          YAML.stubs(:load).raises(ArgumentError)
        end
        
        it 'should fail' do  
          lambda { Report.from_yaml(@yaml) }.should raise_error
        end
        
        it 'should not create a new Report' do
          Report.expects(:create!).never
          lambda { Report.from_yaml(@yaml) }
        end
      end
      
      it 'should create a new report' do
        Report.expects(:create!).returns(@report)
        Report.from_yaml(@yaml)
      end
      
      it 'should set the report details from the original YAML string' do
        Report.expects(:create!).with {|args| args[:details] == @yaml }.returns(@report)
        Report.from_yaml(@yaml)
      end
      
      it 'should set the timestamp of the report to the timestamp of the Puppet report' do
        Report.expects(:create!).with {|args| args[:timestamp] == @thawed.time }.returns(@report)
        Report.from_yaml(@yaml)
      end
      
      it 'should look up the node for the report' do
        Node.expects(:find_by_name).with(@thawed.host).returns(@node)
        Report.from_yaml(@yaml)
      end
      
      describe 'if no matching node is found' do
        before :each do
          Node.stubs(:find_by_name).returns(nil)
          Node.stubs(:create!).returns(@node)
        end
        
        it 'should create a new node for the report' do
          Node.expects(:create!).returns(@node)
          Report.from_yaml(@yaml)
        end
        
        it 'should use the report node name as the new node name' do
          Node.expects(:create!).with {|args| args[:name] == @thawed.host }.returns(@node)
          Report.from_yaml(@yaml)          
        end
        
        it 'should associate the new report with the new node' do
          Report.from_yaml(@yaml).node.should == @node
        end
      end
      
      describe 'if a matching node is found' do
        it 'should associate the new report with the matching node' do
          Report.from_yaml(@yaml).node.should == @node
        end    
      end
      
      it 'should pass the logs on to be created by the log model' do
        rep = YAML.load(@yaml)
        YAML.stubs(:load).returns(rep)
        Report.stubs(:create!).returns(@report)
        @report.logs.expects(:from_puppet_logs).with(rep.logs)
        Report.from_yaml(@yaml)
      end
      
      it 'should pass the metrics on to be created by the metric model' do
        rep = YAML.load(@yaml)
        YAML.stubs(:load).returns(rep)
        Report.stubs(:create!).returns(@report)
        @report.metrics.expects(:from_puppet_metrics).with(rep.metrics)
        Report.from_yaml(@yaml)
      end

      it 'should return the created report' do
        Report.stubs(:create!).returns(@report)
        Report.from_yaml(@yaml).should == @report
      end
    end
  end

  # NOTE: this test isn't as great as it could be, but I can't just test separate
  # Log or Metric objects for equality even if they have all the same values
  it 'should handle serialized YAML details' do
    report = Report.new(:details => @yaml)
    report_details = report.details
    yaml_details = YAML.load(@yaml)
    
    report_details.host.should == yaml_details.host
    report_details.time.should == yaml_details.time
  end
  
  it 'should get reports in a time interval' do
    Report.should respond_to(:between)
  end
  
  describe 'getting reports in a time interval' do
    before :each do
      Report.delete_all
      
      @time = Time.zone.now
      @start_time = @time - 123
      @end_time   = @start_time + 1000
      
      @reports = []
      @reports.push Report.generate!(:timestamp => @start_time - 1)
      10.times do |i|
        @reports.push Report.generate!(:timestamp => @start_time + (100 * i))
      end
      @reports.push Report.generate!(:timestamp => @end_time)
      @reports.push Report.generate!(:timestamp => @end_time + 1)
    end
    
    it 'should accept start and end times' do
      lambda { Report.between(@start_time, @end_time) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require an end time' do
      lambda { Report.between(@start_time) }.should raise_error(ArgumentError)
    end
    
    it 'should require a start time' do
      lambda { Report.between }.should raise_error(ArgumentError)
    end
    
    it 'should return reports with timestamps between the two times' do
      Report.between(@start_time, @end_time).sort_by(&:id).should == @reports[1..-3].sort_by(&:id)
    end
    
    it 'should accept options' do
      lambda { Report.between(@start_time, @end_time, :interval => 100) }.should_not raise_error(ArgumentError)
    end
    
    describe 'when given an interval' do
      it 'should return an array of reports for each interval' do
        Report.between(@start_time, @end_time, :interval => 100).should == @reports[1..-3].collect { |rep|  [rep] }
      end
      
      it 'should include a partial interval at the end' do
        Report.between(@start_time, @end_time, :interval => 300).should == [@reports[1..3], @reports[4..6], @reports[7..9], [@reports[10]]]
      end
    end
  end
  
  it 'should count reports in a time interval' do
    Report.should respond_to(:count_between)
  end
  
  describe 'counting reports in a time interval' do
    before :each do
      Report.delete_all
      
      @time = Time.zone.now
      @start_time = @time - 123
      @end_time   = @start_time + 1000
      
      @reports = []
      @reports.push Report.generate!(:timestamp => @start_time - 1)
      10.times do |i|
        @reports.push Report.generate!(:timestamp => @start_time + (100 * i))
      end
      @reports.push Report.generate!(:timestamp => @end_time)
      @reports.push Report.generate!(:timestamp => @end_time + 1)
    end
    
    it 'should accept start and end times' do
      lambda { Report.count_between(@start_time, @end_time) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require an end time' do
      lambda { Report.count_between(@start_time) }.should raise_error(ArgumentError)
    end
    
    it 'should require a start time' do
      lambda { Report.count_between }.should raise_error(ArgumentError)
    end
    
    it 'should return reports with timestamps between the two times' do
      Report.count_between(@start_time, @end_time).should == 10
    end
    
    it 'should accept options' do
      lambda { Report.count_between(@start_time, @end_time, :interval => 100) }.should_not raise_error(ArgumentError)
    end
    
    describe 'when given an interval' do
      it 'should return an array of counts for each interval' do
        Report.count_between(@start_time, @end_time, :interval => 100).should == [1] * 10
      end
      
      it 'should include a partial interval at the end' do
        Report.count_between(@start_time, @end_time, :interval => 300).should == [3, 3, 3, 1]
      end
    end
    
    it 'should check for a find scope' do
      Report.expects(:scope).with(:find)
      Report.count_between(@start_time, @end_time)
    end
    
    describe 'when there is no find scope' do
      before :each do
        Report.stubs(:scope).returns(nil)
      end
      
      it 'should return a count for all reports' do
        Report.count_between(@start_time, @end_time).should == 10
      end
    end
    
    describe 'when there is a find scope' do
      describe 'with conditions' do
        before :each do
          Report.stubs(:scope).returns({:conditions => %Q["reports".node_id = #{@reports[5].node.id}]})
        end
        
        it 'should limit the count to reports matching the scope' do
          Report.count_between(@start_time, @end_time).should == 1
        end
      end
      
      describe 'without conditions' do
        before :each do
          Report.stubs(:scope).returns({})
        end
        
        it 'should return a count for all reports' do
          Report.count_between(@start_time, @end_time).should == 10
        end
      end
    end
  end
end
