require File.dirname(__FILE__) + '/../spec_helper'

describe "running the puppet_show Puppet report" do
  def run_report
    eval File.read(File.join(RAILS_ROOT, 'puppet', 'report', 'puppet_show.rb'))
  end
  
  before :each do
    Puppet::Reports.stubs(:register_report).yields
    @puppet_settings = stub('puppet settings', :use => true)
    self.stubs(:desc)
    Puppet.stubs(:settings).returns(@puppet_settings)
  end
  
  it "should register the report under the name 'puppet_show'" do
    Puppet::Reports.expects(:register_report).with(:puppet_show)
    run_report
  end
  
  it 'should use the puppet reporting settings' do
    @puppet_settings.expects(:use).with(:reporting)
    run_report
  end
  
  it 'should provide a description for the report' do
    self.expects(:desc)
    run_report
  end

  describe 'when processing the report' do
    it 'should not accept any arguments' do
      pending("there being some actual way to test the process method declared inside of register_report")
    end
    
    it 'should generate a YAML representation of the report' do
      pending("there being some actual way to test the process method declared inside of register_report")
    end
  end
  
  describe 'when submitting YAML data' do
    before :each do
      @yaml = report_yaml
      self.stubs(:to_yaml).returns(@yaml)
      run_report
    end

    it 'should require YAML data' do
      lambda { submit_yaml_report_to_puppetshow }.should raise_error(ArgumentError)
    end
    
    it 'should look up the endpoint for submitting report data' do
      self.expects(:lookup_connection_settings)
      submit_yaml_report_to_puppetshow(@yaml)
    end
    
    it 'should submit the YAML representation to the submission endpoint'
    
    describe 'if the submission fails' do
      it 'should log the failure'
    end
  end
  
  describe 'when looking up data for the submission endpoint' do
    it 'should not accept any arguments'
    it 'should return a host string'
  end
end
