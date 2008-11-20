require File.dirname(__FILE__) + '/../spec_helper'

describe ThinkingSphinxIndexMatcher::HaveIndex do
  before :each do
    @expected = 'some val'
    @target   = 'some tgt'
    @matcher  = ThinkingSphinxIndexMatcher::HaveIndex.new(@expected)
  end
  
  describe 'when initialized' do
    it 'should accept an expected value' do
      lambda { ThinkingSphinxIndexMatcher::HaveIndex.new(@expected) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require an expected value' do
      lambda { ThinkingSphinxIndexMatcher::HaveIndex.new }.should raise_error(ArgumentError)
    end
    
    it 'should store the expected value' do
      ThinkingSphinxIndexMatcher::HaveIndex.new(@expected).instance_variable_get('@expected').should == @expected
    end
  end
  
  it 'should have a failure message' do
    @matcher.should respond_to(:failure_message)
  end
  
  describe 'failure message' do
    before :each do
      @matcher.instance_variable_set('@target', @target)
    end
    
    it 'should explain the problem, containing the target and expected value' do
      @matcher.failure_message.should == 'expected some tgt to index some val'
    end
  end
  
  it 'should have a negative failure message' do
    @matcher.should respond_to(:negative_failure_message)
  end
  
  describe 'negative failure message' do
    before :each do
      @matcher.instance_variable_set('@target', @target)
    end
    
    it 'should explain the problem, containing the target and expected value' do
      @matcher.negative_failure_message.should == 'expected some tgt not to index some val, but did'
    end
  end
  
  it 'should tell if a target matches the expectation' do
    @matcher.should respond_to(:matches?)
  end
  
  describe 'telling if a target matches the expectation' do
    before :each do
      @target.stubs(:sphinx_indexes).returns([])
    end
    
    it 'should accept a target' do
      lambda { @matcher.matches?(@target) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a target' do
      lambda { @matcher.matches? }.should raise_error(ArgumentError)
    end
    
    it 'should set the target' do
      @matcher.matches?(@target)
      @matcher.instance_variable_get('@target').should == @target
    end
    
    it "should go through the target's indexes" do
      @target.expects(:sphinx_indexes).returns([])
      @matcher.matches?(@target)
    end
    
    describe 'when the target has no indexes' do
      before :each do
        @target.stubs(:sphinx_indexes).returns([])
      end
      
      it 'should return a false value' do
        result = @matcher.matches?(@target)
        (!!result).should == false
      end
    end
    
    describe 'when the target has indexes' do
      describe 'and an index includes the expected value' do
        before :each do
          indexes = [
            stub('index', :fields => []),
            stub('index', :fields => [stub('field', :columns => [])]),
            stub('index', :fields => [stub('field', :columns => [stub('column', :__name => 'blah')])]),
            stub('index', :fields => [stub('field', :columns => [stub('column', :__name => @expected)])]),
            stub('index', :fields => [stub('field', :columns => [stub('column', :__name => 'other'), stub('column', :__name => 'feh')])])
          ]
          @target.stubs(:sphinx_indexes).returns(indexes)
        end
        
        it 'should return a true value' do
          result = @matcher.matches?(@target)
          (!!result).should == true
        end
      end
    
      describe 'and no index includes the expected value' do
        before :each do
          indexes = [
            stub('index', :fields => []),
            stub('index', :fields => [stub('field', :columns => [])]),
            stub('index', :fields => [stub('field', :columns => [stub('column', :__name => 'blah')])]),
            stub('index', :fields => [stub('field', :columns => [stub('column', :__name => 'other'), stub('column', :__name => 'feh')])])
          ]
          @target.stubs(:sphinx_indexes).returns(indexes)
        end
        
        it 'should return a false value' do
          result = @matcher.matches?(@target)
          (!!result).should == false
        end
      end
    end
  end
end

describe ThinkingSphinxIndexMatcher do
  before :each do
    @expected = 'some val'
    @helper = Object.new
    @helper.extend(ThinkingSphinxIndexMatcher)
    @matcher = stub('matcher')
    ThinkingSphinxIndexMatcher::HaveIndex.stubs(:new).returns(@matcher)
  end
  
  it "should provide a 'have_index' method" do
    @helper.should respond_to(:have_index)
  end
  
  describe "'have_index' method" do
    it 'should accept an expected value' do
      lambda { @helper.have_index(@expected) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require an expected value' do
      lambda { @helper.have_index }.should raise_error(ArgumentError)
    end
    
    it 'should create a matcher for the expected value' do
      ThinkingSphinxIndexMatcher::HaveIndex.expects(:new).with(@expected)
      @helper.have_index(@expected)
    end
    
    it 'should return the matcher' do
      @helper.have_index(@expected).should == @matcher
    end
  end
end
