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
    
    it 'should pass the report to the submitter' do
      pending("there being some actual way to test the process method declared inside of register_report")
    end
  end
  
  describe 'when submitting YAML data' do
    before :each do
      @yaml = report_yaml
      @report = stub('report', :to_yaml => @yaml)
      self.stubs(:network_post)
      run_report
    end

    it 'should require the report instance' do
      lambda { submit_yaml_report_to_puppetshow }.should raise_error(ArgumentError)
    end
    
    it 'should convert the report instance to yaml' do
      @report.expects(:to_yaml).returns(@yaml)
      submit_yaml_report_to_puppetshow(@report)
    end

    it 'should submit the yaml data to puppetshow' do
      self.expects(:network_post).with(@yaml)
      submit_yaml_report_to_puppetshow(@report)
    end
  end

  describe 'when posting data' do
    before :each do
      @yaml = report_yaml
      @details = { :host => '127.0.0.1', :port => 34343 }
      Net::HTTP.stubs(:start).returns('result')
      self.stubs(:connection_settings).returns(@details)
      run_report
    end

    it "should look up connection details" do
      self.expects(:connection_settings).returns(@details)
      network_post @yaml
    end

    it "should use the appropriate remote server" do
      Net::HTTP.expects(:start).with {|host, port| host == @details[:host] }
      network_post @yaml
    end

    it "should use the appropriate remote port" do
      Net::HTTP.expects(:start).with {|host, port| port == @details[:port] }
      network_post @yaml
    end

    it "should use the POST http method" do
      @mock_result = stub('mock result', :body => 'result')
      @mock_connection = mock('mock http connection', :post => @mock_result)
      self.stubs(:network).yields(@mock_connection)
      network_post @yaml
    end

    describe 'if the submission fails' do
      it 'should log the failure'
    end
  end
  
  describe 'when looking up data for the submission endpoint' do
    before :each do
      run_report
    end

    it 'should not accept any arguments' do
      lambda { connection_settings('foo') }.should raise_error(ArgumentError)
    end
    
    it 'should return a host' do
      connection_settings.should have_key(:host)
    end
    
    it 'should return a port' do
      connection_settings.should have_key(:port)
    end
  end
end
