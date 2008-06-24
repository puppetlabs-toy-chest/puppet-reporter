require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NodesController do
  
  it_should_behave_like 'a RESTful controller with an index action'

  before :each do
    @node = Node.new(:name => 'foo')
    @node.stubs(:most_recent_report_on).returns(@report)
    @report = Report.new
    Node.stubs(:find).returns(@node)
  end

  describe 'show' do
    def do_get(params = {})
      get :show, {}.merge(params)
    end

    it "should be successful" do
      do_get('id' => '1')
      response.should be_success
    end
  
    it "should render the show template" do
      do_get('id' => '1')
      response.should render_template('show')
    end
  
    it "should find the node requested" do
      Node.expects(:find).with('1').returns(@node)
      do_get('id' => '1')
    end

    it "should make the found object available to the view" do
      do_get('id' => '1')
      assigns[:node].should == @node
    end

    describe 'when a node name is specified' do
      it 'should look up the node by name' do
        Node.expects(:find_by_name).returns(@node)
        do_get('id' => 'foo')
      end
      
      describe 'and the node cannot be found' do
        before :each do
          Node.stubs(:find_by_name).returns(nil)
        end
        
        it 'should set a flash message about not being able to find the node' do
          do_get('id' => 'foo')
          flash[:notice].should match(/find/)
        end
        
        it 'should redirect to the node index page' do
          do_get('id' => 'foo')
          response.should redirect_to(nodes_path)
        end
      end
      
      describe 'and the node can be found' do
        before :each do
          Node.stubs(:find_by_name).returns(@node)          
        end

        it 'should make the node available to the view' do
          do_get('id' => 'foo')
          assigns[:node].should == @node
        end
        
        it 'should render the node show page' do
          do_get('id' => 'foo')
          response.should render_template('show')
        end
        
        it 'should look up the most recent node report' do
          @node.expects(:most_recent_report_on).returns(@report)
          do_get('id' => 'foo')
        end
                
        it 'should make the most recent node report available to the view' do
          @node.stubs(:most_recent_report_on).returns(@report)
          do_get('id' => 'foo')
          assigns[:most_recent_report].should == @report
        end
      end
    end
    
    describe 'when a node name is not specified' do
      describe 'but a numeric id is specified' do
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
  
  describe 'failures' do
    def do_get(params = {})
      get :failures, {}.merge(params)
    end

    it "should be successful" do
      do_get('id' => '1')
      response.should be_success
    end
  
    it "should render the failures template" do
      do_get('id' => '1')
      response.should render_template('failures')
    end
  
    it "should find the node requested" do
      Node.expects(:find).with('1').returns(@node)
      do_get('id' => '1')
    end

    it "should make the found object available to the view" do
      do_get('id' => '1')
      assigns[:node].should == @node
    end

    describe 'when a node name is specified' do
      it 'should look up the node by name' do
        Node.expects(:find_by_name).returns(@node)
        do_get('id' => 'foo')
      end
      
      describe 'and the node cannot be found' do
        before :each do
          Node.stubs(:find_by_name).returns(nil)
        end
        
        it 'should set a flash message about not being able to find the node' do
          do_get('id' => 'foo')
          flash[:notice].should match(/find/)
        end
        
        it 'should redirect to the node index page' do
          do_get('id' => 'foo')
          response.should redirect_to(nodes_path)
        end
      end
      
      describe 'and the node can be found' do
        before :each do
          Node.stubs(:find_by_name).returns(@node)   
          @failures = stub('failures')       
        end

        it 'should make the node available to the view' do
          do_get('id' => 'foo')
          assigns[:node].should == @node
        end
        
        it 'should render the node failures page' do
          do_get('id' => 'foo')
          response.should render_template('failures')
        end
        
        it 'should render failures as text' do
          do_get('id' => 'foo')
          response.content_type.should == 'text/plain'
        end
        
        it 'should look up the failures for the node' do
          @node.expects(:failures).returns(@failures)
          do_get('id' => 'foo')
        end
                
        it 'should make the most recent node report available to the view' do
          @node.stubs(:failures).returns(@failures)
          do_get('id' => 'foo')
          assigns[:failures].should == @failures
        end
      end
    end
    
    describe 'when a node name is not specified' do
      describe 'but a numeric id is specified' do
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
  
  describe 'reports' do
    before :each do
      @reports = stub('reports')
    end
    
    def do_get(params = {})
      get :reports, {}.merge(params)
    end

    it "should be successful" do
      do_get('id' => '1')
      response.should be_success
    end
  
    it "should render the reports template" do
      do_get('id' => '1')
      response.should render_template('reports')
    end
  
    it "should find the node requested" do
      Node.expects(:find).with('1').returns(@node)
      do_get('id' => '1')
    end

    it "should make the found object available to the view" do
      do_get('id' => '1')
      assigns[:node].should == @node
    end

    describe 'when a node name is specified' do
      it 'should look up the node by name' do
        Node.expects(:find_by_name).returns(@node)
        do_get('id' => 'foo')
      end
      
      describe 'and the node cannot be found' do
        before :each do
          Node.stubs(:find_by_name).returns(nil)
        end
        
        it 'should set a flash message about not being able to find the node' do
          do_get('id' => 'foo')
          flash[:notice].should match(/find/)
        end
        
        it 'should redirect to the node index page' do
          do_get('id' => 'foo')
          response.should redirect_to(nodes_path)
        end
      end
      
      describe 'and the node can be found' do
        before :each do
          Node.stubs(:find_by_name).returns(@node)   
        end

        it 'should make the node available to the view' do
          do_get('id' => 'foo')
          assigns[:node].should == @node
        end
        
        it 'should look up the reports for the node' do
          @node.expects(:reports).returns(@reports)
          do_get('id' => 'foo')
        end
                
        it 'should render the node reports page' do
          do_get('id' => 'foo')
          response.should render_template('reports')
        end
        
        it 'should render reports as xml' do
          do_get('id' => 'foo')
          response.content_type.should == 'application/xml'
        end
        
        it 'should make the most recent node report available to the view in increasing chronological order' do
          @node.stubs(:reports).returns(@reports)
          do_get('id' => 'foo')
          assigns[:reports].should == @reports.sort_by(&:timestamp)
        end
      end
    end
    
    describe 'when a node name is not specified' do
      describe 'but a numeric id is specified' do
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
