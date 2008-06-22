require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController, "when running integrations" do
  integrate_views

  describe 'when showing a report' do
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
  
  describe 'when receiving reports via create' do
    def do_request(params = {})
      post :create, {}.merge(params)
    end
    
    describe 'and no report data is received' do
      it 'should fail' do
        do_request
        response.should be_error
      end
      
      it 'should not create any reports' do
        do_request
        lambda { do_request 'report' => @yaml }.should_not change(Report, :count)
      end      
    end
    
    describe 'and invalid report data is received' do
      before :each do
        @yaml = 'this is not a valid report, yo.'
      end

      it 'should fail' do
        do_request 'report' => @yaml
        response.should be_error
      end
      
      it 'should not create any reports' do
        do_request 'report' => @yaml
        lambda { do_request 'report' => @yaml }.should_not change(Report, :count)
      end
    end
    
    describe 'and valid report data is received' do
      before :each do
        @yaml = report_yaml
      end

      it 'should succeed' do
        do_request 'report' => @yaml
        response.should be_success
      end
      
      it 'should result in reports being created' do
        lambda { do_request 'report' => @yaml }.should change(Report, :count)
      end
    end
  end
end
