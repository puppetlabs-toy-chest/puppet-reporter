require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Log do
  before :each do
    @log = Log.new
  end
  
  it 'should have a level' do
    @log.should respond_to(:level)
  end
  
  it 'should have a message' do
    @log.should respond_to(:message)
  end
  
  it 'should have a source' do
    @log.should respond_to(:source)
  end
  
  it 'should have a timestamp' do
    @log.should respond_to(:timestamp)
  end
  
  it 'should have tags' do
    @log.should respond_to(:tags)
  end
  
  it 'should belong to report' do
    @log.should respond_to(:report)
  end
  
  describe 'validation' do
    before :each do
      @log = Log.generate!
    end
    
    it 'should error on report if no report given' do
      @log.report = nil
      @log.should_not be_valid
      @log.errors.should be_invalid(:report)
    end
    
    it 'should not error on report if report given' do
      @log.report = Report.new
      @log.should be_valid
    end
    
    it 'should error on level if no level given' do
      @log.level = nil
      @log.should_not be_valid
      @log.errors.should be_invalid(:level)
    end
    
    it 'should not error on level if level given' do
      @log.level = 'warn'
      @log.should be_valid
    end
    
    it 'should error on message if no message given' do
      @log.message = nil
      @log.should_not be_valid
      @log.errors.should be_invalid(:message)
    end
    
    it 'should not error on message if message given' do
      @log.message = 'this is a log message'
      @log.should be_valid
    end
    
    it 'should error on timestamp if no timestamp given' do
      @log.timestamp = nil
      @log.should_not be_valid
      @log.errors.should be_invalid(:timestamp)
    end
    
    it 'should not error on timestamp if timestamp given' do
      @log.timestamp = Time.zone.now
      @log.should be_valid
    end
  end
  
  it 'should belong to a node through its report' do
    @log = Log.generate!
    @log.node.should == @log.report.node
  end
  
  it 'should create logs from puppet data' do
    Log.should respond_to(:from_puppet_logs)
  end
  
  describe 'creating logs from puppet data' do
    before :each do
      @log = stub('log', :level => 'err', :message => 'log message', :source => 'log source', :time => Time.zone.now, :tags => [])
      @logs = [@log]
      Log.stubs(:create)
    end
    
    it 'should require log data' do
      lambda { Log.from_puppet_logs }.should raise_error(ArgumentError)
    end
    
    it 'should accept log data' do
      lambda { Log.from_puppet_logs(@logs) }.should_not raise_error(ArgumentError)
    end
    
    it 'should create a log' do
      Log.expects(:create)
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the log level' do
      level = @log.level
      Log.expects(:create).with(has_entry(:level => level))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should handle a symbol level' do
      level = @log.level
      @log.stubs(:level).returns(level.to_sym)
      Log.expects(:create).with(has_entry(:level => level))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the log message' do
      Log.expects(:create).with(has_entry(:message => @log.message))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the log source' do
      Log.expects(:create).with(has_entry(:source => @log.source))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the log timestamp' do
      Log.expects(:create).with(has_entry(:timestamp => @log.time))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the tags to be a sorted, comma-separated list of the tags' do
      @log.stubs(:tags).returns(%w[file main osx darwin source])
      expected_tags = 'darwin, file, main, osx, source'
      Log.expects(:create).with(has_entry(:tags => expected_tags))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should handle symbol tags' do
      @log.stubs(:tags).returns([:file, :main, :osx, :darwin, :source])
      expected_tags = 'darwin, file, main, osx, source'
      Log.expects(:create).with(has_entry(:tags => expected_tags))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the tags to the empty string if there are no tags' do
      @log.stubs(:tags).returns([])
      Log.expects(:create).with(has_entry(:tags => ''))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the tags to the empty string if there are nil tags' do
      @log.stubs(:tags).returns(nil)
      Log.expects(:create).with(has_entry(:tags => ''))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should create a log for each element of the log data' do
      other_log = stub('log', :level => 'warn', :message => 'log message 2', :source => 'log source 2', :time => Time.zone.now - 134, :tags => [])
      @logs.push other_log
      
      @logs.each do |log|
        Log.expects(:create).with(has_entry(:message => log.message))
      end
      Log.from_puppet_logs(@logs)
    end
    
    it 'should create no logs if the log data is empty' do
      Log.expects(:create).never
      Log.from_puppet_logs(@logs)
    end
  end
end
