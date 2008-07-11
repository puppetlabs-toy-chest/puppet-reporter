require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  describe 'index' do
    before :each do
      @failed = stub('failed nodes')
      Node.stubs(:failed).returns(@failed)
      
      @silent = stub('silent nodes')
      Node.stubs(:silent).returns(@silent)
      
      @logs = stub('recent logs')
      Log.stubs(:recent).returns(@logs)
    end
    
    def do_get
      get :index
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should get failed nodes' do
      Node.expects(:failed)
      do_get
    end
    
    it 'should assign failed nodes for the view' do
      do_get
      assigns[:failed_nodes].should == @failed
    end
    
    it 'should get nodes not checked in' do
      Node.expects(:silent)
      do_get
    end
    
    it 'should assign nodes not checked in for the view' do
      do_get
      assigns[:silent_nodes].should == @silent
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
