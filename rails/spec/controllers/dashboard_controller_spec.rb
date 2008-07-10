require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  describe 'index' do
    def do_get
      get :index
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
  end
end
