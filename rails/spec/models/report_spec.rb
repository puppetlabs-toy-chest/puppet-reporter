require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Report do
  before :each do
  # sorry for making this hard as shit to read -- wanted to get some realism here.
  @yaml = '--- !ruby/object:Puppet::Transaction::Report 
    host: phage.madstop.com
    logs: 
      - !ruby/object:Puppet::Util::Log 
        level: :err
        message: "Failed to retrieve current state of resource: cannot convert nil into String"
        objectsource: true
        source: //basenode/puppetclient/remotefile[/etc/puppet/puppet.conf]/File[/etc/puppet/puppet.conf]
        tags: 
          - :basenode
          - :main
          - :puppetclient
          - :remotefile
          - :file
          - :source
        time: 2007-05-31 17:05:52.188748 -05:00
      - !ruby/object:Puppet::Util::Log 
        level: :notice
        message: executed successfully
        objectsource: true
        source: //basenode/os::darwin/Exec[/bin/echo yaytest]/returns
        tags: 
          - :basenode
          - :main
          - :os::darwin
          - :exec
          - :testing
          - :returns
        time: 2007-05-31 17:05:53.698169 -05:00
    metrics: 
      time: !ruby/object:Puppet::Util::Metric 
        label: Time
        name: time
        values: 
          - 
            - :filebucket
            - Filebucket
            - 0.000102043151855469
          - 
            - :notify
            - Notify
            - 0.000590801239013672
          - 
            - :total
            - Total
            - 2.97548842430115
          - 
            - :exec
            - Exec
            - 0.011544942855835
          - 
            - :schedule
            - Schedule
            - 0.000103950500488281
          - 
            - :config_retrieval
            - Config retrieval
            - 0.150889158248901
          - 
            - :user
            - User
            - 0.124068021774292
          - 
            - :file
            - File
            - 2.68818950653076
      resources: !ruby/object:Puppet::Util::Metric 
        label: Resources
        name: resources
        values: 
          - 
            - :restarted
            - Restarted
            - 0
          - 
            - :applied
            - Applied
            - 1
          - 
            - :failed_restarts
            - Failed restarts
            - 0
          - 
            - :total
            - Total
            - 29
          - 
            - :skipped
            - Skipped
            - 0
          - 
            - :failed
            - Failed
            - 1
          - 
            - :scheduled
            - Scheduled
            - 23
          - 
            - :out_of_sync
            - Out of sync
            - 2
      changes: !ruby/object:Puppet::Util::Metric 
        label: Changes
        name: changes
        values: 
          - 
            - :total
            - Total
            - 2
    records: {}
    time: 2007-05-31 17:05:53.824906 -05:00
    '
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
  end
  
  describe 'as a class' do
    describe 'loading report data from YAML files' do
      before :each do
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
      
      describe 'if the yaml contains a log' do
        before :each do
          @old_yaml = @yaml
          rep = YAML.load(@yaml)
          @logs = rep.logs
          @log = @logs.first
          rep.logs = [@log]
          @yaml = rep.to_yaml
          Report.stubs(:create!).returns(@report)
        end
        
        it 'should create a log object' do
          @report.logs.expects(:create)
          Report.from_yaml(@yaml)
        end
        
        it 'should set the log level' do
          @report.logs.expects(:create).with(has_entry(:level => @log.level.to_s))
          Report.from_yaml(@yaml)
        end
        
        it 'should set the log message' do
          @report.logs.expects(:create).with(has_entry(:message => @log.message))
          Report.from_yaml(@yaml)
        end
        
        it 'should set the log source' do
          @report.logs.expects(:create).with(has_entry(:source => @log.source))
          Report.from_yaml(@yaml)
        end
        
        it 'should set the log timestamp' do
          @report.logs.expects(:create).with(has_entry(:timestamp => @log.time))
          Report.from_yaml(@yaml)
        end
        
        it 'should set the log tags to a sorted, comma-separated list of the yaml log tags' do
          rep = YAML.load(@yaml)
          log = rep.logs.first
          log.tags = %w[file main osx darwin source]
          rep.logs = [log]
          expected_tags = 'darwin, file, main, osx, source'
          
          @report.logs.expects(:create).with(has_entry(:tags => expected_tags))
          Report.from_yaml(rep.to_yaml)
        end
        
        it 'should handle symbol tags' do
          rep = YAML.load(@yaml)
          log = rep.logs.first
          log.tags = [:file, :main, :osx, :darwin, :source]
          rep.logs = [log]
          expected_tags = 'darwin, file, main, osx, source'
          
          @report.logs.expects(:create).with(has_entry(:tags => expected_tags))
          Report.from_yaml(rep.to_yaml)
        end
        
        it 'should not set tags to the empty string if the yaml log has no tags' do
          rep = YAML.load(@yaml)
          log = rep.logs.first
          log.tags = []
          rep.logs = [log]
          
          @report.logs.expects(:create).with(has_entry(:tags => ''))
          Report.from_yaml(rep.to_yaml)
        end
        
        it 'should create a log object for each yaml log' do
          @logs.each do |log|
            @report.logs.expects(:create).with(has_entry(:message => log.message))
          end
          
          Report.from_yaml(@old_yaml)
        end
      end
      
      describe 'if the yaml contains no logs' do
        before :each do
          rep = YAML.load(@yaml)
          rep.logs = []
          @yaml = rep.to_yaml
          Report.stubs(:create!).returns(@report)
        end
        
        it 'should create no log objects' do
          @report.logs.expects(:create).never
          Report.from_yaml(@yaml)
        end
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
  
  it "should delegate 'dtl_logs' to its details (logs)" do
    report = Report.new
    report.stubs(:details).returns(stub('details', :logs => stub('logs')))
    report.dtl_logs.should == report.details.logs
  end
  
  it "should delegate 'metrics' to its details" do
    report = Report.new
    report.stubs(:details).returns(stub('details', :metrics => stub('metrics')))
    report.metrics.should == report.details.metrics
  end
end
