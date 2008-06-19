require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MetricsController, "when running integrations" do
  integrate_views

  describe 'show' do
    before :all do
      Metric.delete_all
    end
    
    def do_request(params)
      get :show, {}.merge(params)
    end
    
    describe 'when no matching metric exists' do
      it 'should set a flash message about the report not matching' do
        do_request('id' => '1')
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the metrics index page' do
        do_request('id' => '1')
        response.should redirect_to(metrics_path)
      end
    end
    
    describe 'when a matching report exists' do
      before :all do
        @metric = Metric.generate!
      end
      
      it 'should make the metric available to the view' do
        do_request('id' => @metric.id)
        assigns[:metric].should == @metric
      end
      
      it 'should show the metric page' do
        do_request('id' => @metric.id)
        response.should render_template('show')
      end      
    end
  end
end
