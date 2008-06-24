require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NodesController, "when running integrations" do
  integrate_views

  describe 'show' do
    before :all do
      Node.delete_all
    end
    
    def do_request
      get :show, :id => 'foo'
    end
    
    describe 'when no matching node exists' do
      it 'should set a flash message about the node not matching' do
        do_request
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the node summary page' do
        do_request
        response.should redirect_to(nodes_path)
      end
    end
    
    describe 'when a matching node exists' do
      before :all do
        @node = Node.generate(:name => 'foo')
      end
      
      it 'should make the node available to the view' do
        do_request
        assigns[:node].should == @node
      end
      
      it 'should show the node page' do
        do_request
        response.should render_template('show')
      end
      
      describe 'when the node has reports' do
        before :each do
          @time = 1.day.ago
          @node.reports.generate(:timestamp => @time)
        end
        
        it 'should show the time of the most recent report' do
          do_request
          response.should_not have_text(/Never reported/)
        end
      end
      
      describe 'when the node has no reports' do
        it 'should indicate that the node never reported in' do
          do_request
          response.should have_text(/Never reported/)
        end
      end
    end
  end
  
  describe 'failures' do
    before :all do
      Node.delete_all
    end
    
    def do_request
      get :failures, :id => 'foo'
    end
    
    describe 'when no matching node exists' do
      it 'should set a flash message about the node not matching' do
        do_request
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the node summary page' do
        do_request
        response.should redirect_to(nodes_path)
      end
    end
    
    describe 'when a matching node exists' do
      before :all do
        @node = Node.generate(:name => 'foo')
      end
      
      it 'should make the node available to the view' do
        pending("rspec learning about alternative templates") do
          do_request
          assigns[:node].should == @node
        end
      end
      
      it 'should show the failures page' do
        pending("rspec learning about alternative templates") do |variable|
          do_request
          response.should render_template('failures.csv.erb')          
        end
      end
    end
  end

  describe 'reports' do
    before :all do
      Node.delete_all
    end
    
    def do_request
      get :reports, :id => 'foo'
    end
    
    describe 'when no matching node exists' do
      it 'should set a flash message about the node not matching' do
        do_request
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the node summary page' do
        do_request
        response.should redirect_to(nodes_path)
      end
    end
    
    describe 'when a matching node exists' do
      before :all do
        @node = Node.generate(:name => 'foo')
      end
      
      it 'should make the node available to the view' do
        pending("rspec learning about alternative templates") do
          do_request
          assigns[:node].should == @node
        end
      end
      
      it 'should show the reports page' do
        pending("rspec learning about alternative templates") do |variable|
          do_request
          response.should render_template('reports.xml.builder')          
        end
      end
    end
  end
end
