require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do

  it_should_behave_like 'a RESTful controller with a show action'
  
  describe 'show' do
    def do_get(params)
      get :show, {}.merge(params)
    end
    
    describe 'when no matching report can be found' do
      before :each do
        Report.expects(:find).raises(ActiveRecord::RecordNotFound)
      end
      
      it 'should set a flash warning about the failure' do
        do_get('id' => '1')
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the report index page' do
        do_get('id' => '1')
        response.should redirect_to(reports_path)        
      end
    end
  end
  
  describe 'when receiving a new report from Puppet' do
    def do_post(params = {})
      post :create, {}.merge(params)
    end
    
    describe 'and no report data is received' do
      it 'should return an error' do
        do_post
        response.should be_error
      end
      
      it 'should not have created any new reports' do
        Report.expects(:from_yaml).never
      end
    end
    
    # TODO:  if we wish to deal with authentication on creating Reports, this is where it would happen
    
    describe 'and report data is received' do
      before :each do
        @yaml = report_yaml
      end
      
      it 'should attempt to create a report using the data' do
        Report.expects(:from_yaml).with(@yaml)
        do_post('report' => @yaml)
      end
      
      describe 'but report creation fails' do
        before :each do
          Report.stubs(:from_yaml).raises(Exception)          
        end
        
        it 'should return an error' do
          do_post('report' => @yaml)
          response.should be_error
        end
        
        it 'should not have created any new reports' do
          lambda { do_post('report' => @yaml) }.should_not change(Report, :count)
        end
      end
      
      describe 'and report creation succeeds' do
        it 'should return success' do
          do_post('report' => @yaml)
          response.should be_success
        end
        
        it 'should have created a new report' do
          lambda { do_post('report' => @yaml) }.should change(Report, :count)
        end
      end
    end
  end
end
