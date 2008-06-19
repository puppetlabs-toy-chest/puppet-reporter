require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Metric do
  before(:each) do
    @metric = Metric.new
  end

  it "should be valid" do
    @metric.should be_valid
  end
end
