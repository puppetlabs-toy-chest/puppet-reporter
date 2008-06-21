require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/index.html.erb' do
  
  before :each do
    @node = Node.generate!(:name => 'foo')
    assigns[:nodes] = [@node]
    template.stubs(:report_count_graph).returns('report count graph goes here')
    template.stubs(:node_report_count_graph).returns('node report count graph goes here')
    template.stubs(:total_change_graph).returns('total change graph goes here')
    template.stubs(:node_total_change_graph).returns('node total change graph goes here')
    template.stubs(:total_failure_graph).returns('total failure graph goes here')
    template.stubs(:node_total_failure_graph).returns('node total failure graph goes here')
    template.stubs(:total_resource_graph).returns('total resource graph goes here')
    template.stubs(:node_total_resource_graph).returns('node total resource graph goes here')
    @now = Time.zone.now
    Time.zone.stubs(:now).returns(@now)
  end

  def do_render
    render '/nodes/index.html.erb'
  end

  it 'should include the node list' do
    do_render
    response.should have_tag('table[class=?][id=?]', 'node_list', 'node_list')
  end
  
  it 'should include a report count graph' do
    do_render
    response.should have_tag('table[id=?]', 'node_list') do
      with_tag('thead', :text => Regexp.new(Regexp.escape('report count graph goes here')))
    end
  end
  
  it 'should base the report count graph off now' do
    template.expects(:report_count_graph).with(@now)
    do_render
  end
  
  it 'should include a total change graph' do
    do_render
    response.should have_tag('table[id=?]', 'node_list') do
      with_tag('thead', :text => Regexp.new(Regexp.escape('total change graph goes here')))
    end
  end
  
  it 'should base the total change graph off now' do
    template.expects(:total_change_graph).with(@now)
    do_render
  end
  
  it 'should include a total failure graph' do
    do_render
    response.should have_tag('table[id=?]', 'node_list') do
      with_tag('thead', :text => Regexp.new(Regexp.escape('total failure graph goes here')))
    end
  end
  
  it 'should base the total failure graph off now' do
    template.expects(:total_failure_graph).with(@now)
    do_render
  end
  
  it 'should include a total resource graph' do
    do_render
    response.should have_tag('table[id=?]', 'node_list') do
      with_tag('thead', :text => Regexp.new(Regexp.escape('total resource graph goes here')))
    end
  end
  
  it 'should base the total resource graph off now' do
    template.expects(:total_resource_graph).with(@now)
    do_render
  end
  
  describe 'node list' do
    it 'should include a node list item' do
      do_render
      response.should have_tag('table[id=?]', 'node_list') do
        with_tag('tr[id=?]', "node-#{@node.id}")
      end
    end
    
    describe 'node list item' do
      it 'should include the node name' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape(@node.name)))
      end
      
      it 'should include a link to the node' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}") do
          with_tag('a[href=?]', node_path(@node))
        end
      end
      
      it 'should include a report count graph for the node' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape('node report count graph goes here')))
      end
      
      it 'should get the report count graph for the node' do
        template.expects(:node_report_count_graph).with(@node, anything)
        do_render
      end
      
      it 'should base the node report count graph off now' do
        template.expects(:node_report_count_graph).with(anything, @now)
        do_render
      end
      
      it 'should include a total change graph for the node' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape('node total change graph goes here')))
      end
      
      it 'should get the total change graph for the node' do
        template.expects(:node_total_change_graph).with(@node, anything)
        do_render
      end
      
      it 'should base the node total change graph off now' do
        template.expects(:node_total_change_graph).with(anything, @now)
        do_render
      end
      
      it 'should include a total failure graph for the node' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape('node total failure graph goes here')))
      end
      
      it 'should get the total failure graph for the node' do
        template.expects(:node_total_failure_graph).with(@node, anything)
        do_render
      end
      
      it 'should base the node total failure graph off now' do
        template.expects(:node_total_failure_graph).with(anything, @now)
        do_render
      end
      
      it 'should include a total resource graph for the node' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape('node total resource graph goes here')))
      end
      
      it 'should get the total resource graph for the node' do
        template.expects(:node_total_resource_graph).with(@node, anything)
        do_render
      end
      
      it 'should base the node total resource graph off now' do
        template.expects(:node_total_resource_graph).with(anything, @now)
        do_render
      end
    end
    
    it 'should include a list item for every node' do
      other_node = Node.generate!
      nodes = [@node, other_node]
      assigns[:nodes] = nodes
      
      do_render
      response.should have_tag('table[id=?]', 'node_list') do
        nodes.each do |node|
          with_tag('tr[id=?]', "node-#{node.id}")
        end
      end
    end
    
    it 'should include no list items if there are no nodes' do
      assigns[:nodes] = []
      do_render
      response.should have_tag('table[id=?]', 'node_list') do
        with_tag('tbody') do
          without_tag('tr')
        end
      end
    end
  end
end
