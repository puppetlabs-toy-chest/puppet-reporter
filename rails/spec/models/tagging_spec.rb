require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tagging do
  before :each do
    @tagging = Tagging.new
  end
  
  it 'should belong to tag' do
    @tagging.should respond_to(:tag)
  end
  
  it 'should belong to log' do
    @tagging.should respond_to(:log)
  end
end
