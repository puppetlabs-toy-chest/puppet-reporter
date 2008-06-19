require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reports/show" do
  before(:each) do
    @node = Node.generate!
    @report = @node.reports.generate!
    @log = stub('log', :level => 'log level', :message => 'log message', :time => Time.zone.now, :tags => [])
    @report.stubs(:logs).returns([@log])
    assigns[:report] = @report
  end
  
  def do_render
    render 'reports/show'
  end
  
  it 'should include the node name' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@node.name)))
  end
  
  it 'should include a link to the node' do
    do_render
    response.should have_tag('a[href=?]', node_path(@node))
  end
  
  it 'should show the report time' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@report.timestamp.to_s)))
  end
  
  it 'should include report details' do
    do_render
    response.should have_tag('div[id=?]', 'report_details')
  end
  
  describe 'report details' do
    it 'should include logs' do
      do_render
      response.should have_tag('div[id=?]', 'report_details') do
        with_tag('ul[id=?]', 'report_logs')
      end
    end
    
    describe 'logs' do
      it 'should include a log item' do
        do_render
        response.should have_tag('ul[id=?]', 'report_logs') do
          with_tag('li')
        end
      end
      
      describe 'log item' do
        it 'should include log level' do
          do_render
          response.should have_tag('ul[id=?]', 'report_logs') do
            with_tag('li', :text => Regexp.new(Regexp.escape(@log.level)))
          end
        end
        
        it 'should include log message' do
          do_render
          response.should have_tag('ul[id=?]', 'report_logs') do
            with_tag('li', :text => Regexp.new(Regexp.escape(@log.message)))
          end
        end
        
        it 'should include log time' do
          do_render
          response.should have_tag('ul[id=?]', 'report_logs') do
            with_tag('li', :text => Regexp.new(Regexp.escape(@log.time.to_s)))
          end
        end

        describe 'when log has tags' do
          before :each do
            @tags = ['basenode', 'main', 'os::darwin']
            @log.stubs(:tags).returns(@tags)
          end
          
          it "should include a sorted comma-separated list of the log's tags" do
            do_render
            response.should have_tag('ul[id=?]', 'report_logs') do
              with_tag('li', :text => Regexp.new(Regexp.escape(@tags.sort.join(', '))))
            end
          end
          
          it 'should handle tags that are symbols' do
            @log.stubs(:tags).returns([:basenode, :main, :'os::darwin'])
            do_render
            response.should have_tag('ul[id=?]', 'report_logs') do
              with_tag('li', :text => Regexp.new(Regexp.escape(@tags.sort.join(', '))))
            end
          end
        end
        
        describe 'when log has no tags' do
          before :each do
            @log.stubs(:tags).returns([])
          end
          
          it 'should not include any tag information for the log' do
            do_render
            response.should have_tag('ul[id=?]', 'report_logs') do
              without_tag('li', :text => Regexp.new(/tags:/))
            end            
          end
        end
      end
      
      it 'should include a log item for each log' do
        other_log = stub('log', :level => 'log level 2', :message => 'log message 2', :tags => [], :time => Time.zone.now - 3456)
        logs = [@log, other_log]
        @report.stubs(:logs).returns(logs)
        
        do_render
        response.should have_tag('ul[id=?]', 'report_logs') do
          logs.each do |log|
            with_tag('li', :text => Regexp.new(Regexp.escape(log.message)))
          end
        end
      end
      
      it 'should include no items if there are no logs' do
        @report.stubs(:logs).returns([])
        do_render
        response.should have_tag('ul[id=?]', 'report_logs') do
          without_tag('li')
        end
      end
    end
  end
end
