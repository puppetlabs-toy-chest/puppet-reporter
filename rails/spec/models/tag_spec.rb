require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do
  before :each do
    @tag = Tag.new
  end
  
  it 'should have a name' do
    @tag.should respond_to(:name)
  end
  
  it 'should have many taggings' do
    @tag.should respond_to(:taggings)
  end
  
  it 'should have many logs' do
    @tag.should respond_to(:logs)
  end
  
  describe 'as a class' do
    it 'should return tags with counts' do
      Tag.should respond_to(:with_counts)
    end
    
    describe 'returning tags with counts' do
      before :each do
        @tags = []
        @tags.push Tag.create!(:name => 'tag one')
        @tags.push Tag.create!(:name => 'tag two')
        @tags.push Tag.create!(:name => 'tag three')
        
        @logs = Array.new(10) { Log.generate! }
        
        @logs[3, 5].each { |log|  @tags[1].logs << log }
        @logs[5, 4].each { |log|  @tags[2].logs << log }
      end
      
      it 'should not return crazy amounts of tags' do
        Tag.with_counts.length.should == @tags.length
      end
      
      it 'should return all tags' do
        result = Tag.with_counts
        @tags.each do |tag|
          result.should include(tag)
        end
      end
      
      it 'should include counts in the tags' do
        Tag.with_counts.each do |tag|
          tag.should respond_to(:count)
        end
      end
      
      it "should use the number of taggings as a tag's count" do
        result = Tag.with_counts
        
        result.detect { |t|  t.name == @tags[0].name }.count.should == 0
        result.detect { |t|  t.name == @tags[1].name }.count.should == 5
        result.detect { |t|  t.name == @tags[2].name }.count.should == 4
      end
      
      it 'should order the tags by count, highest first' do
        Tag.with_counts.should == @tags.values_at(1,2,0)
      end
    end
  end
end
