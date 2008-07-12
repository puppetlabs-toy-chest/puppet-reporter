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
  
  it 'should have many taggings' do
    @log.should respond_to(:taggings)
  end
  
  it 'should have many tags' do
    @log.should respond_to(:tags)
  end
  
  it 'should return tag names' do
    @log.should respond_to(:tag_names)
  end
  
  describe 'tag names' do
    it 'should be a sorted, comma-separated list of tag names' do
      tags = []
      %w[file main osx darwin source].each do |tag_name|
        tags.push stub('tag', :name => tag_name)
      end
      @log.stubs(:tags).returns(tags)
      expected_tags = 'darwin, file, main, osx, source'
      @log.tag_names.should == expected_tags
    end
    
    it 'should be the empty string if there are no tags' do
      @log.stubs(:tags).returns([])
      @log.tag_names.should == ''
    end
  end
  
  it 'should allow setting tag names' do
    @log.should respond_to(:tag_names=)
  end
  
  describe 'setting tag names' do
    it 'should create tags for the given names' do
      @log.tag_names = 'one, two, three'
      %w[one two three].each do |tag_name|
        Tag.find_by_name(tag_name).should be_kind_of(Tag)
      end
    end
    
    it 'should set the taggings for the log' do
      @log.tag_names = 'four, five, six'
      @log.taggings.collect { |t|  t.tag.name }.sort.should == %w[four five six].sort
    end
    
    it 'should save the tags when the log is saved' do
      @log = Log.spawn
      @log.tag_names = 'four, five, six'
      @log.save!
      @log.tag_names.should == 'five, four, six'
    end
    
    it 'should not create already-present tags' do
      Tag.create!(:name => 'seven')
      @log.tag_names = 'seven, eight, nine'
      Tag.count(:conditions => { :name => 'seven' } ).should == 1
    end
    
    it 'should link to already-present tags' do
      tag = Tag.create!(:name => 'seven')
      @log = Log.spawn
      @log.tag_names = 'seven, eight, nine'
      @log.save!
      @log.tags.should include(tag)
    end
    
    it 'should remove no-longer-needed taggings'
    it 'should not remove tags'
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
    
    it 'should set the tag names to be a sorted, comma-separated list of the tags' do
      @log.stubs(:tags).returns(%w[file main osx darwin source])
      expected_tags = 'darwin, file, main, osx, source'
      Log.expects(:create).with(has_entry(:tag_names => expected_tags))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should handle symbol tags' do
      @log.stubs(:tags).returns([:file, :main, :osx, :darwin, :source])
      expected_tags = 'darwin, file, main, osx, source'
      Log.expects(:create).with(has_entry(:tag_names => expected_tags))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the tag names to the empty string if there are no tags' do
      @log.stubs(:tags).returns([])
      Log.expects(:create).with(has_entry(:tag_names => ''))
      Log.from_puppet_logs(@logs)
    end
    
    it 'should set the tag names to the empty string if there are nil tags' do
      @log.stubs(:tags).returns(nil)
      Log.expects(:create).with(has_entry(:tag_names => ''))
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
  
  describe 'as a class' do
    it 'should get recent logs' do
      Log.should respond_to(:recent)
    end
    
    describe 'getting recent logs' do
      before :each do
        @now_log       = Log.generate!(:timestamp => Time.zone.now)
        @recent_log    = Log.generate!(:timestamp => Time.zone.now - 5)
        @while_ago_log = Log.generate!(:timestamp => Time.zone.now - 29.5.minutes)
        @old_log       = Log.generate!(:timestamp => Time.zone.now - 40.minutes)
      end
      
      it 'should return logs within the past 30 minutes' do
        recent = Log.recent
        
        [@now_log, @recent_log, @while_ago_log].each do |log|
          recent.should include(log)
        end
      end
      
      it 'should not return logs from more than 30 minutes ago' do
        Log.recent.should_not include(@old_log)
      end
      
      it 'should order the logs by timestamp, most recent first' do
        Log.generate!(:timestamp => Time.zone.now - 10.minutes)
        recent = Log.recent
        recent.should == recent.sort_by(&:timestamp).reverse
      end
      
      it 'should return at most 5 results' do
        10.times { |i| Log.generate!(:timestamp => Time.zone.now - i) }
        Log.recent.length.should == 5
      end
      
      it 'should return fewer results if fewer match' do
        Log.recent.length.should == 3
      end
      
      it 'should return the most recent results' do
        10.times { |i| Log.generate!(:timestamp => Time.zone.now - i) }
        Log.recent.should_not include(@while_ago_log)
      end
      
      it 'should return the empty list if there are no matching logs' do
        [@now_log, @recent_log, @while_ago_log].each(&:destroy)
        Log.recent.should == []
      end
      
      it 'should return the empty list if there are no logs' do
        Log.delete_all
        Log.recent.should == []
      end
    end
      
    it 'should get latest logs' do
      Log.should respond_to(:latest)
    end

    describe 'getting latest logs' do
      before :each do
        @now_log       = Log.generate!(:timestamp => Time.zone.now)
        @recent_log    = Log.generate!(:timestamp => Time.zone.now - 5)
        @while_ago_log = Log.generate!(:timestamp => Time.zone.now - 29.5.minutes)
        @old_log       = Log.generate!(:timestamp => Time.zone.now - 40.minutes)
      end
      
      it 'should return the most recent logs' do
        latest = Log.latest
        
        [@now_log, @recent_log, @while_ago_log].each do |log|
          latest.should include(log)
        end
      end
      
      it 'should order the logs by timestamp, most recent first' do
        Log.generate!(:timestamp => Time.zone.now - 10.minutes)
        latest = Log.latest
        latest.should == latest.sort_by(&:timestamp).reverse
      end
      
      it 'should return at most 5 results' do
        10.times { |i| Log.generate!(:timestamp => Time.zone.now - i) }
        Log.latest.length.should == 5
      end
      
      it 'should return fewer results if fewer match' do
        Log.latest.length.should == 4
      end
      
      it 'should return the most recent results' do
        10.times { |i| Log.generate!(:timestamp => Time.zone.now - i) }
        Log.latest.should_not include(@while_ago_log)
      end
      
      it 'should return the empty list if there are no logs' do
        Log.delete_all
        Log.recent.should == []
      end
    end
  end
end
