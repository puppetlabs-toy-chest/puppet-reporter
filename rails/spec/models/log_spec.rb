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
end
