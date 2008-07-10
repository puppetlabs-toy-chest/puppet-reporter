require File.dirname(__FILE__) + '/../../spec_helper'

describe '/dashboard/index.html.erb' do
  before :each do
    @failed = Node.generate!
    assigns[:failed_nodes] = [@failed]
    @silent = Node.generate!
    assigns[:silent_nodes] = [@silent]
  end
  
  def do_render
    render '/dashboard/index.html.erb'
  end
  
  it 'should include content' do
    do_render
    response.should have_tag('div[id=?]', 'content')
  end
  
  it 'should include node status' do
    do_render
    response.should have_tag('div[id=?]', 'node_status')
  end
  
  describe 'node status' do
    it 'should include failed nodes' do
      do_render
      response.should have_tag('div[id=?]', 'node_status') do
        with_tag('div[id=?]', 'failed_nodes')
      end
    end
    
    describe 'failed nodes' do
      it 'should include a list of nodes' do
        do_render
        response.should have_tag('div[id=?]', 'failed_nodes') do
          with_tag('ul')
        end
      end
      
      it 'should include a list item for the node' do
        do_render
        response.should have_tag('div[id=?]', 'failed_nodes') do
          with_tag('ul') do
            with_tag('li')
          end
        end
      end
      
      it 'should display the node name' do
        do_render
        response.should have_tag('div[id=?]', 'failed_nodes') do
          with_tag('ul') do
            with_tag('li', :text => Regexp.new(Regexp.escape(@failed.name)))
          end
        end
      end
      
      it 'should link to the node' do
        do_render
        response.should have_tag('div[id=?]', 'failed_nodes') do
          with_tag('ul') do
            with_tag('li') do
              with_tag('a[href=?]', node_path(@failed))
            end
          end
        end
      end
      
      it 'should include an item for each node' do
        other_failed = Node.generate!
        nodes = [@failed, other_failed]
        assigns[:failed_nodes] = nodes
        
        do_render
        response.should have_tag('div[id=?]', 'failed_nodes') do
          with_tag('ul') do
            nodes.each do |node|
              with_tag('li', :text => Regexp.new(Regexp.escape(node.name)))
            end
          end
        end
      end
      
      it 'should include no items if there are no nodes' do
        assigns[:failed_nodes] = []
        
        do_render
        response.should have_tag('div[id=?]', 'failed_nodes') do
          with_tag('ul') do
            without_tag('li')
          end
        end
      end
    end
    
    it 'should include nodes not checked in' do
      do_render
      response.should have_tag('div[id=?]', 'node_status') do
        with_tag('div[id=?]', 'silent_nodes')
      end
    end
    
    describe 'nodes not checked in' do
      it 'should include a list of nodes' do
        do_render
        response.should have_tag('div[id=?]', 'silent_nodes') do
          with_tag('ul')
        end
      end
      
      it 'should include a list item for the node' do
        do_render
        response.should have_tag('div[id=?]', 'silent_nodes') do
          with_tag('ul') do
            with_tag('li')
          end
        end
      end
      
      it 'should display the node name' do
        do_render
        response.should have_tag('div[id=?]', 'silent_nodes') do
          with_tag('ul') do
            with_tag('li', :text => Regexp.new(Regexp.escape(@silent.name)))
          end
        end
      end
      
      it 'should link to the node' do
        do_render
        response.should have_tag('div[id=?]', 'silent_nodes') do
          with_tag('ul') do
            with_tag('li') do
              with_tag('a[href=?]', node_path(@silent))
            end
          end
        end
      end
      
      it 'should include an item for each node' do
        other_silent = Node.generate!
        nodes = [@silent, other_silent]
        assigns[:silent_nodes] = nodes
        
        do_render
        response.should have_tag('div[id=?]', 'silent_nodes') do
          with_tag('ul') do
            nodes.each do |node|
              with_tag('li', :text => Regexp.new(Regexp.escape(node.name)))
            end
          end
        end
      end
      
      it 'should include no items if there are no nodes' do
        assigns[:silent_nodes] = []
        
        do_render
        response.should have_tag('div[id=?]', 'silent_nodes') do
          with_tag('ul') do
            without_tag('li')
          end
        end
      end
    end
  end
  
  it 'should include logs'
  it 'should include a log tag cloud'
end
