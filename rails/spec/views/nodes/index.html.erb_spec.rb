require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/index.html.erb' do
  before :each do
    @node = Node.generate!(:name => 'foo')
    assigns[:nodes] = [@node]
    template.stubs(:report_count_graph).returns('report count graph goes here')
  end

  def do_render
    render '/nodes/index.html.erb'
  end

  it 'should include the node list' do
    do_render
    response.should have_tag('ul[class=?][id=?]', 'node_list', 'node_list')
  end
  
  it 'should include a report count graph' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape('report count graph goes here')))
  end
  
  describe 'node list' do
    it 'should include a node list item' do
      do_render
      response.should have_tag('ul[id=?]', 'node_list') do
        with_tag('li[id=?]', "node-#{@node.id}")
      end
    end
    
    describe 'node list item' do
      it 'should include the node name' do
        do_render
        response.should have_tag('li[id=?]', "node-#{@node.id}", :text => Regexp.new(Regexp.escape(@node.name)))
      end
      
      it 'should include a link to the node' do
        do_render
        response.should have_tag('li[id=?]', "node-#{@node.id}") do
          with_tag('a[href=?]', node_path(@node))
        end
      end
    end
    
    it 'should include a list item for every node' do
      other_node = Node.generate!
      nodes = [@node, other_node]
      assigns[:nodes] = nodes
      
      do_render
      response.should have_tag('ul[id=?]', 'node_list') do
        nodes.each do |node|
          with_tag('li[id=?]', "node-#{node.id}")
        end
      end
    end
    
    it 'should include no list items if there are no nodes' do
      assigns[:nodes] = []
      do_render
      response.should have_tag('ul[id=?]', 'node_list') do
        without_tag('li')
      end
    end
  end
end
