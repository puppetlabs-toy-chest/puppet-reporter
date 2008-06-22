require File.dirname(__FILE__) + '/../spec_helper'

describe "running the puppet_show Puppet report" do
  def run_report
    eval File.read(File.join(RAILS_ROOT, 'puppet', 'report', 'puppet_show.rb'))
  end
  
  it "should register the report under the name 'puppet_show'"
  it 'should use the puppet reporting settings'
  it 'should provide a description for the report'

  describe 'when processing the report' do
    before :each do
      @yaml = report_yaml
      self.stubs(:to_yaml).returns(@yaml)
    end

    it 'should not accept any arguments'
    it 'should generate a YAML representation of the report'
  end
  
  describe 'when submitting YAML data' do
    it 'should require '
    it 'should look up the endpoint for submitting report data'
    it 'should submit the YAML representation to the submission endpoint'

    describe 'if the submission fails' do
      
    end
    
    describe 'if the submission succeeds' do
      
    end
  end
  
  describe 'when looking up data for the submission endpoint' do
    it 'should not accept any arguments'
    it 'should return a '
  end
end
