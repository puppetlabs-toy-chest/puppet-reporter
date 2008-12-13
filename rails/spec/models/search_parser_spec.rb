require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchParser do
  it 'should be able to parse a search string' do
    SearchParser.should respond_to(:parse)
  end

  describe 'parsing a search string' do
    it 'should accept a search string' do
      lambda { SearchParser.parse('query') }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a search string' do
      lambda { SearchParser.parse }.should raise_error(ArgumentError)
    end
    
    it 'should return the search string' do
      SearchParser.parse('query').should == 'query'
    end
  end
end
