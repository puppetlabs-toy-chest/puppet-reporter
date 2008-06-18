require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Report do
  before(:each) do
    @report = Report.new
  end

  describe 'when validating' do    
    it "should be valid" do
      @report.should be_valid
    end
  end
  
  describe 'associations' do
    it 'can have a node' do
      @report.node.should be_nil
    end
  end
end
