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
end
