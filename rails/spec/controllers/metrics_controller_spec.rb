require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MetricsController do
  it_should_behave_like 'a RESTful controller with a show action'
  
  describe 'show' do
    def do_get(params)
      get :show, {}.merge(params)
    end
    
    describe 'when no matching metric can be found' do
      before :each do
        Metric.expects(:find).raises(ActiveRecord::RecordNotFound)
      end
      
      it 'should set a flash warning about the failure' do
        do_get('id' => '1')
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the metric index page' do
        do_get('id' => '1')
        response.should redirect_to(metrics_path)        
      end
    end
  end

end
