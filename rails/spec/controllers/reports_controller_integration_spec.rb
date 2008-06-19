require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController, "when running integrations" do
  integrate_views

  describe 'show' do
    before :all do
      Report.delete_all
    end
    
    def do_request(params)
      get :show, {}.merge(params)
    end
    
    describe 'when no matching report exists' do
      it 'should set a flash message about the report not matching' do
        do_request('id' => '1')
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the report index page' do
        do_request('id' => '1')
        response.should redirect_to(reports_path)
      end
    end
    
    describe 'when a matching report exists' do
      before :all do
        @report = Report.generate!
      end
      
      it 'should make the report available to the view' do
        do_request('id' => @report.id)
        assigns[:report].should == @report
      end
      
      it 'should show the report page' do
        do_request('id' => @report.id)
        response.should render_template('show')
      end      
    end
  end
end
