require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NodesController, "when running integrations" do
  integrate_views

  describe 'show' do
    before :all do
      Node.delete_all
    end
    
    def do_request
      get :show, :name => 'foo'
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
    end
  end
end
