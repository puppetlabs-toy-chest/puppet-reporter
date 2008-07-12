require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LogsController do
  describe 'recent' do
    before :each do
      @logs = stub('recent logs')
      Log.stubs(:recent).returns(@logs)
    end
    
    def do_get
      get :recent
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should get recent logs' do
      Log.expects(:recent)
      do_get
    end
    
    it 'should assign recent logs for the view' do
      do_get
      assigns[:logs].should == @logs
    end
  end
end
