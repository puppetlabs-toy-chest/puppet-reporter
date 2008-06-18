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
end
