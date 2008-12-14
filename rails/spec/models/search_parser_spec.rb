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

    describe 'when no keywords are present' do
      before :each do
        @query = 'query'
      end

      it 'should treat the search string as a name' do
        SearchParser.parse(@query).should == { :name => @query }
      end
    end

    describe 'when keywords are present' do
      it 'should associate non-keyworded terms with the name keyword' do
        result = SearchParser.parse('key:foo something else bar:baz')
        result[:name].should == 'something else'
      end

      it 'should associated keyworded terms with their keywords' do
        result = SearchParser.parse('key:foo something else bar:baz')
        result[:key].should == 'foo'
        result[:bar].should == 'baz'
      end

      it 'should keep double-quoted keyworded strings intact' do
        result = SearchParser.parse('key:"foo bar" something else')
        result[:key].should == 'foo bar'
      end

      it 'should keep single-quoted keyworded strings intact' do
        result = SearchParser.parse("key:'foo bar' something else")
        result[:key].should == 'foo bar'
      end

      it 'should merge any explicit name with non-keyworded terms' do
        result = SearchParser.parse("key:'foo bar' something else name:xyzzy")
        result[:name].should == 'something else xyzzy'
      end
    end
  end
end
