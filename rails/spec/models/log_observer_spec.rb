require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LogObserver do
  
  class LogObserver
    def initialize
    end
  end
  
  before :each do
    @observer = LogObserver.instance
  end
  
  it 'should observe Log' do
    LogObserver.observed_class.should == Log
  end
  
  it 'should have an after-create callback' do
    @observer.should respond_to(:after_create)
  end
  
  describe 'after-create callback' do
    before :each do
      @log = Log.spawn
      @page = stub_everything('page')
      @controller = stub('controller')
      @controller.stubs(:render).yields(@page)
      @observer.stubs(:controller).returns(@controller)
    end
    
    it 'should accept a log' do
      lambda { @observer.after_create(@log) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a log' do
      lambda { @observer.after_create }.should raise_error(ArgumentError)
    end
    
    it 'should request its controller' do
      @observer.expects(:controller).returns(@controller)
      @observer.after_create(@log)
    end
    
    it 'should use the controller to render juggernaut' do
      @controller.expects(:render).with(:juggernaut)
      @observer.after_create(@log)
    end
    
    it 'should insert the log on the page' do
      @page.expects(:insert_html).with(:after, 'scrolling_logs_top', :partial => 'logs/log', :locals => { :log => @log })
      @observer.after_create(@log)
    end
  end
  
  it 'should create a controller' do
    @observer.should respond_to(:controller)
  end
  
  describe 'creating a controller' do
    it 'should return a controller' do
      @observer.controller.should be_kind_of(ActionController::Base)
    end
    
    it 'should return a controller with a template set' do
      @observer.controller.instance_variable_get('@template').should be_kind_of(ActionView::Base)
    end
    
    it 'should set the view paths for the template' do
      ActionView::Base.expects(:new).with(ActionController::Base.view_paths, anything, anything)
      @observer.controller
    end
    
    it 'should set the controller for the template' do
      controller = @observer.controller
      controller.instance_variable_get('@template').controller.should == controller
    end
    
    it 'should return a controller with assigns set' do
      @observer.controller.instance_variable_get('@assigns').should == {}
    end
    
    it 'should return a controller with the request set' do
      @observer.controller.request.should be_kind_of(ActionController::CgiRequest)
    end
    
    it 'should set the CGI for the request' do
      @observer.controller.request.cgi.should be_kind_of(CGI)
    end
    
    it 'should return a controller with the params set' do
      @observer.controller.params.should == {}
    end
    
    it 'should return a controller with the URL rewriter set' do
      @observer.controller.instance_variable_get('@url').should be_kind_of(ActionController::UrlRewriter)
    end
  end
end
