require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/index.html.erb' do
  
  before :each do
    @node = Node.generate!(:name => 'foo')
    assigns[:nodes] = [@node]
    template.stubs(:report_count_graph).returns('report count graph goes here')
    template.stubs(:node_report_count_graph).returns('node report count graph goes here')
    template.stubs(:total_change_graph).returns('total change graph goes here')
    template.stubs(:node_total_change_graph).returns('node total change graph goes here')
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
  
  it 'should include a total change graph' do
    do_render
    response.should have_tag('table[id=?]', 'node_list') do
      with_tag('thead', :text => Regexp.new(Regexp.escape('total change graph goes here')))
    end
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
        template.expects(:node_report_count_graph).with(@node)
        do_render
      end
      
      it 'should include a total change graph for the node' do
        do_render
        response.should have_tag('tr[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape('node total change graph goes here')))
      end
      
      it 'should get the total change graph for the node' do
        template.expects(:node_total_change_graph).with(@node)
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
