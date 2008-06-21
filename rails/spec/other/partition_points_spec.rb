require File.dirname(__FILE__) + '/../spec_helper'

describe Range do
  before :each do
    @range = 1..6
  end
  
  it 'should get partition points' do
    @range.should respond_to(:partition_points)
  end
  
  describe 'getting partition points' do
    it 'should require an interval' do
      lambda { @range.partition_points }.should raise_error(ArgumentError)
    end
    
    it 'should accept an interval' do
      lambda { @range.partition_points(1) }.should_not raise_error(ArgumentError)
    end
    
    it 'should return points within the range separated by the given interval' do
      @range.partition_points(1).should == [1, 2, 3, 4, 5, 6]
    end
    
    it 'should return a point for a partial partition at the end' do
      @range.partition_points(2).should == [1, 3, 5, 6]
    end
    
    it 'should work with objects other than numbers' do
      time = Time.zone.now
      @range = time .. (time + 5)
      
      @range.partition_points(2).should == [time, time + 2, time + 4, time + 5]
    end
  end
  
  it 'should get partitions' do
    @range.should respond_to(:partitions)
  end
  
  describe 'getting partitions' do
    it 'should require an interval' do
      lambda { @range.partitions }.should raise_error(ArgumentError)
    end
    
    it 'should accept an interval' do
      lambda { @range.partitions(1) }.should_not raise_error(ArgumentError)
    end
    
    it 'should return partitions within the range separated by the given interval' do
      @range.partitions(1).should == [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]
    end
    
    it 'should return a partial partition at the end' do
      @range.partitions(2).should == [[1, 3], [3, 5], [5, 6]]
    end
    
    it 'should work with objects other than numbers' do
      time = Time.zone.now
      @range = time .. (time + 5)
      
      @range.partitions(2).should == [[time, time + 2], [time + 2, time + 4], [time + 4, time + 5]]
    end
  end
end
