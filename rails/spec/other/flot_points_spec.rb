require File.dirname(__FILE__) + '/../spec_helper'

describe Array do
  before :each do
    @array = [1,2,3,4,5,6]
  end
  
  it 'should get flot points' do
    @array.should respond_to(:flot_points)
  end
  
  describe 'getting flot points' do
    it 'should be the array elements with indices in the form [[i, elem] ...]' do
      @array.flot_points.should == [[0,1], [1,2], [2,3], [3,4], [4,5], [5,6]]
    end
  end
end
