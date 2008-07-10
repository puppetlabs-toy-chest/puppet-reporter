require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  describe 'index' do
    before :each do
      @failed = stub('failed nodes')
      Node.stubs(:failed).returns(@failed)
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
  end
end
