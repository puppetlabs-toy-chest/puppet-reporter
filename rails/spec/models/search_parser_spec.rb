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
      
      it 'should keep wildcard markers intact' do
        SearchParser.parse('*blah*').should == { :name => '*blah*' }
      end
      
      it 'should handle a wildcard marker only at the start' do
        SearchParser.parse('*blah').should == { :name => '*blah' }
      end
      
      it 'should handle a wildcard marker only at the end' do
        SearchParser.parse('blah*').should == { :name => 'blah*' }
      end
      
      it 'should combine terms into a multiple-check name parameter' do
        SearchParser.parse('something else').should == { :name => 'something,else' }
      end
      
    end

    describe 'when keywords are present' do
      it 'should associate non-keyworded terms with the name keyword' do
        result = SearchParser.parse('key:foo something bar:baz')
        result[:name].should == 'something'
      end
      
      it 'should combine non-keyworded terms into a multiple-check name parameter' do
        result = SearchParser.parse('key:foo something else bar:baz')
        result[:name].should == 'something,else'
      end
      
      it 'should keep wildcard markers intact with a non-keyworded term' do
        result = SearchParser.parse('key:foo *something* bar:baz')
        result[:name].should == '*something*'
      end
      
      it 'should handle a wildcard marker only at the start of a non-keyworded term' do
        result = SearchParser.parse('key:foo *something bar:baz')
        result[:name].should == '*something'
      end
      
      it 'should handle a wildcard marker only at the end of a non-keyworded term' do
        result = SearchParser.parse('key:foo something* bar:baz')
        result[:name].should == 'something*'
      end

      it 'should associated keyworded terms with their keywords' do
        result = SearchParser.parse('key:foo something else bar:baz')
        result[:key].should == 'foo'
        result[:bar].should == 'baz'
      end

      it 'should combine keyworded terms into a multiple-check parameter' do
        result = SearchParser.parse('key:foo key:goo something else bar:baz')
        result[:key].should == 'foo,goo'
      end

      it 'should keep double-quoted keyworded strings intact' do
        result = SearchParser.parse('key:"foo bar" something else')
        result[:key].should == 'foo bar'
      end
      
      it 'should keep wildcard markers intact with a double-quoted keyworded term' do
        result = SearchParser.parse('key:*"foo bar"* something else bar:baz')
        result[:key].should == '*foo bar*'
      end
      
      it 'should handle a wildcard marker only at the start of a double-quoted keyworded term' do
        result = SearchParser.parse('key:*"foo bar" something else bar:baz')
        result[:key].should == '*foo bar'
      end
      
      it 'should handle a wildcard marker only at the end of a double-quoted keyworded term' do
        result = SearchParser.parse('key:"foo bar"* something else bar:baz')
        result[:key].should == 'foo bar*'
      end

      it 'should keep single-quoted keyworded strings intact' do
        result = SearchParser.parse("key:'foo bar' something else")
        result[:key].should == 'foo bar'
      end
      
      it 'should keep wildcard markers intact with a single-quoted keyworded term' do
        result = SearchParser.parse("key:*'foo bar'* something else bar:baz")
        result[:key].should == '*foo bar*'
      end
      
      it 'should handle a wildcard marker only at the start of a single-quoted keyworded term' do
        result = SearchParser.parse("key:*'foo bar' something else bar:baz")
        result[:key].should == '*foo bar'
      end
      
      it 'should handle a wildcard marker only at the end of a single-quoted keyworded term' do
        result = SearchParser.parse("key:'foo bar'* something else bar:baz")
        result[:key].should == 'foo bar*'
      end
      
      it 'should keep wildcard markers intact with a keyworded term' do
        result = SearchParser.parse('key:*foo* something else bar:baz')
        result[:key].should == '*foo*'
      end
      
      it 'should keep wildcard markers intact with a keyworded term' do
        result = SearchParser.parse('key:*foo* something else bar:baz')
        result[:key].should == '*foo*'
      end
      
      it 'should handle a wildcard marker only at the start of a keyworded term' do
        result = SearchParser.parse('key:*foo something else bar:baz')
        result[:key].should == '*foo'
      end
      
      it 'should handle a wildcard marker only at the end of a keyworded term' do
        result = SearchParser.parse('key:foo* something else bar:baz')
        result[:key].should == 'foo*'
      end

      it 'should merge any explicit name with non-keyworded terms' do
        result = SearchParser.parse("key:'foo bar' something else name:xyzzy")
        result[:name].should == 'something,else,xyzzy'
      end
    end
  end
end
