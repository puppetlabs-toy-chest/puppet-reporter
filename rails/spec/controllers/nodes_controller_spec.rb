require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NodesController do

  it_should_behave_like 'a RESTful controller with a show action'  # includes params[:id] specs

  def do_get(params = {})
    get :show, {}.merge(params)
  end

  describe 'show' do
    before :each do
      @node = Node.new(:name => 'foo')
    end
    
    describe 'when a node name is specified' do
      it 'should look up the node by name' do
        Node.expects(:find_by_name).returns(@node)
        do_get('name' => 'foo')
      end
      
      describe 'and the node cannot be found' do
        before :each do
          Node.stubs(:find_by_name).returns(nil)
        end
        
        it 'should set a flash message about not being able to find the node' do
          do_get('name' => 'foo')
          flash[:notice].should match(/find/)
        end
        
        it 'should redirect to the node index page' do
          do_get('name' => 'foo')
          response.should redirect_to(nodes_path)
        end
      end
      
      describe 'and the node can be found' do
        before :each do
          Node.stubs(:find_by_name).returns(@node)          
        end

        it 'should make the node available to the view' do
          do_get('name' => 'foo')
          assigns[:node].should == @node
        end
        
        it 'should render the node show page' do
          do_get('name' => 'foo')
          response.should render_template('show')
        end
      end
    end
    
    describe 'when a node name is not specified' do
      describe 'but an id is specified' do
        it 'should not attempt to look up the node by name' do
          Node.expects(:find_by_name).never
          do_get('id' => 1)
        end
        
        describe 'and the node with that id cannot be found' do
          before :each do
            Node.stubs(:find).raises(ActiveRecord::RecordNotFound)
          end
          
          it 'should set a flash message about not being able to find the node' do
            do_get('id' => 1)
            flash[:notice].should match(/find/)
          end
          
          it 'should redirect to the node index page' do
            do_get('id' => 1)
            response.should redirect_to(nodes_path)
          end
        end
      end
    end

    describe 'when neither a node name or an id is specified' do
      it 'should set a flash message about not being able to find the node' do
        do_get
        flash[:notice].should match(/find/)
      end
      
      it 'should redirect to the node index page' do
        do_get
        response.should redirect_to(nodes_path)
      end
    end
  end
end
