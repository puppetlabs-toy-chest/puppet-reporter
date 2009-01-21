require File.dirname(__FILE__) + '/../../spec_helper'

describe '/dashboard/index' do
  before :each do
    @log = Log.generate!(:source => 'log source')
    assigns[:logs] = [@log]
  end
  
  def do_render
    render '/dashboard/index'
  end
  
  it 'should create a juggernaut object' do
    do_render
    response.should have_text(/jQuery\.Juggernaut\.initialize/)
  end
  
  it 'should include content' do
    do_render
    response.should have_tag('div[id=?]', 'content')
  end
  
  it 'should include a search form' do
    do_render
    response.should have_tag('div[id=?] form[id=?]', 'search', 'search_form')
  end
  
  describe 'search form' do
    it 'should submit to the dashboard search action' do
      do_render
      response.should have_tag('form[id=?][action=?]', 'search_form', search_path)
    end
    
    it 'should use HTTP GET when submitting' do
      do_render
      response.should have_tag('form[id=?][method=?]', 'search_form', 'get')
    end
    
    it 'should include a text field for entering search terms' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[name=?][type=?]', 'q', 'text')
      end
    end
    
    it 'should include a submit button' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[type=?]', 'submit')
      end      
    end
  end

  it 'should include a region for displaying search results' do
    do_render
    response.should have_tag('div[id=?]', 'search_results_container')
  end
  
  it 'should include logs' do
    do_render
    response.should have_tag('div[id=?]', 'logs')
  end
  
  describe 'logs' do
    it 'should include a log table' do
      do_render
      response.should have_tag('div[id=?]', 'logs') do
        with_tag('table[id=?][class=?]', 'scrolling_logs', 'logs')
      end
    end
    
    describe 'log table' do
      it 'should include a top marker' do
        do_render
        response.should have_tag('table[id=?]', 'scrolling_logs') do
          with_tag('tr[id=?]', 'scrolling_logs_top')
        end
      end
      
      it 'should include a log item' do
        do_render
        response.should have_tag('table[id=?]', 'scrolling_logs') do
          with_tag('tr:not([id=?])', 'scrolling_logs_top')
        end
      end
      
      describe 'log item' do
        it 'should include log level' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.level)))
          end
        end
        
        it 'should be classed with log level' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr[class=?]', @log.level)
          end
        end
        
        it 'should include log message' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.message)))
          end
        end
        
        it 'should include log source' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.source)))
          end
        end
        
        it 'should include log time' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.timestamp.to_s)))
          end
        end
        
        it 'should include log node' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.node.name)))
          end
        end
        
        it 'should link to log node' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr') do
              with_tag('a[href=?]', node_path(@log.node))
            end
          end
        end
        
        it 'should include log report' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.report.timestamp.to_s)))
          end
        end
        
        it 'should link to log report' do
          do_render
          response.should have_tag('table[id=?]', 'scrolling_logs') do
            with_tag('tr') do
              with_tag('a[href=?]', report_path(@log.report))
            end
          end
        end
        
        describe 'when log has tags' do
          before :each do
            @tags = 'basenode, main, os::darwin'
            @log.stubs(:tag_names).returns(@tags)
          end
          
          it 'should include the log tags' do
            do_render
            response.should have_tag('table[id=?]', 'scrolling_logs') do
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
            response.should have_tag('table[id=?]', 'scrolling_logs') do
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
        response.should have_tag('table[id=?]', 'scrolling_logs') do
          logs.each do |log|
            with_tag('tr', :text => Regexp.new(Regexp.escape(log.timestamp.to_s)))
          end
        end
      end
      
      it 'should not include log items if there are no logs' do
        assigns[:logs] = []
        
        do_render
        response.should have_tag('table[id=?]', 'scrolling_logs') do
          without_tag('tr:not([id=?])', 'scrolling_logs_top')
        end
      end
    end
  end
end
