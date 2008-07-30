require File.dirname(__FILE__) + '/../../spec_helper'

describe '/dashboard/index.html.erb' do
  before :each do
    @failed = Node.generate!
    assigns[:failed_nodes] = [@failed]
    @silent = Node.generate!
    assigns[:silent_nodes] = [@silent]
    @log = Log.generate!(:source => 'log source')
    assigns[:logs] = [@log]
  end
  
  def do_render
    render '/dashboard/index.html.erb'
  end
  
  it 'should create a juggernaut object' do
    do_render
    response.should have_text(/jQuery\.Juggernaut\.initialize/)
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
  
  it 'should include logs' do
    do_render
    response.should have_tag('div[id=?]', 'logs')
  end
  
  describe 'logs' do
    it 'should include a log table' do
      do_render
      response.should have_tag('div[id=?]', 'logs') do
        with_tag('table[id=?][class=?]', 'dashboard_logs', 'logs')
      end
    end
    
    describe 'log table' do
      it 'should include a top marker' do
        do_render
        response.should have_tag('table[id=?]', 'dashboard_logs') do
          with_tag('tr[id=?]', 'dashboard_logs_top')
        end
      end
      
      it 'should include a log item' do
        do_render
        response.should have_tag('table[id=?]', 'dashboard_logs') do
          with_tag('tr:not([id=?])', 'dashboard_logs_top')
        end
      end
      
      describe 'log item' do
        it 'should include log level' do
          do_render
          response.should have_tag('table[id=?]', 'dashboard_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.level)))
          end
        end
        
        it 'should be classed with log level' do
          do_render
          response.should have_tag('table[id=?]', 'dashboard_logs') do
            with_tag('tr[class=?]', @log.level)
          end
        end
        
        it 'should include log message' do
          do_render
          response.should have_tag('table[id=?]', 'dashboard_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.message)))
          end
        end
        
        it 'should include log source' do
          do_render
          response.should have_tag('table[id=?]', 'dashboard_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.source)))
          end
        end
        
        it 'should include log time' do
          do_render
          response.should have_tag('table[id=?]', 'dashboard_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.timestamp.to_s)))
          end
        end
        
        describe 'when log has tags' do
          before :each do
            @tags = 'basenode, main, os::darwin'
            @log.stubs(:tag_names).returns(@tags)
          end
          
          it 'should include the log tags' do
            do_render
            response.should have_tag('table[id=?]', 'dashboard_logs') do
              with_tag('tr', :text => Regexp.new(Regexp.escape(@tags)))
            end
          end
        end
        
        describe 'when log has no tags' do
          before :each do
            @log.stubs(:tag_names).returns('')
          end
          
          it 'should not include any tag information for the log' do
            do_render
            response.should have_tag('table[id=?]', 'dashboard_logs') do
              without_tag('tr', :text => Regexp.new(/tags:/))
            end            
          end
        end
      end
      
      it 'should include a log item for each log' do
        other_log = Log.generate!(:timestamp => Time.zone.now - 45678)
        logs = [@log, other_log]
        assigns[:logs] = logs
        
        do_render
        response.should have_tag('table[id=?]', 'dashboard_logs') do
          logs.each do |log|
            with_tag('tr', :text => Regexp.new(Regexp.escape(log.timestamp.to_s)))
          end
        end
      end
      
      it 'should not include log items if there are no logs' do
        assigns[:logs] = []
        
        do_render
        response.should have_tag('table[id=?]', 'dashboard_logs') do
          without_tag('tr:not([id=?])', 'dashboard_logs_top')
        end
      end
    end
  end
    
  it 'should include a log tag cloud'
end
