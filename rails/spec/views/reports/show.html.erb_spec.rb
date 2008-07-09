require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reports/show" do
  before(:each) do
    @node = Node.generate!
    @report = @node.reports.generate!
    @log = stub('log', :level => 'log level', :message => 'log message', :source => 'log source', :timestamp => Time.zone.now, :tag_names => '')
    @report.stubs(:logs).returns([@log])
    @metrics = { }
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
        with_tag('table[id=?]', 'report_logs')
      end
    end
    
    describe 'logs' do
      it 'should include a log item' do
        do_render
        response.should have_tag('table[id=?]', 'report_logs') do
          with_tag('tr')
        end
      end
      
      describe 'log item' do
        it 'should include log level' do
          do_render
          response.should have_tag('table[id=?]', 'report_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.level)))
          end
        end
        
        it 'should be classed with log level' do
          do_render
          response.should have_tag('table[id=?]', 'report_logs') do
            with_tag('tr[class=?]', @log.level)
          end
        end
        
        it 'should include log message' do
          do_render
          response.should have_tag('table[id=?]', 'report_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.message)))
          end
        end
        
        it 'should include log source' do
          do_render
          response.should have_tag('table[id=?]', 'report_logs') do
            with_tag('tr', :text => Regexp.new(Regexp.escape(@log.source)))
          end
        end
        
        it 'should include log time' do
          do_render
          response.should have_tag('table[id=?]', 'report_logs') do
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
            response.should have_tag('table[id=?]', 'report_logs') do
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
            response.should have_tag('table[id=?]', 'report_logs') do
              without_tag('tr', :text => Regexp.new(/tags:/))
            end            
          end
        end
      end
      
      it 'should include a log item for each log' do
        other_log = stub('log', :level => 'log level 2', :message => 'log message 2', :source => 'log source 2', :tag_names => '', :timestamp => Time.zone.now - 3456)
        logs = [@log, other_log]
        @report.stubs(:logs).returns(logs)
        
        do_render
        response.should have_tag('table[id=?]', 'report_logs') do
          logs.each do |log|
            with_tag('tr', :text => Regexp.new(Regexp.escape(log.message)))
          end
        end
      end
    end
    
    it 'should not include logs if there are no logs' do
      @report.stubs(:logs).returns([])
      do_render
      response.should have_tag('div[id=?]', 'report_details') do
        without_tag('table[id=?]', 'report_logs')
      end
    end
    
    describe 'metrics' do
      before :each do
        @report = Report.from_yaml(report_yaml)
        assigns[:report] = @report
        @metrics = @report.metrics
        @categories = Metric.categorize(@metrics)
      end
      
      it 'should organize the metrics by categories' do
        Metric.expects(:categorize).with(@metrics).returns(@categories)
        do_render
      end
      
      it 'should include a section for each category' do
        do_render
        @categories.keys.each do |category|
          response.should have_tag('div[class*=?]', "report_#{category}_metrics")
        end
      end
      
      it 'should show the label for each metric in the section for its category' do
        do_render
        @categories.keys.each do |category|
          response.should have_tag('div[class*=?]', "report_#{category}_metrics") do
            @categories[category].each do |metric|
              with_tag('li', Regexp.new(Regexp.escape(metric.label)))
            end
          end
        end        
      end
      
      it 'should show the value for each metric in the section for its category' do
        do_render
        @categories.keys.each do |category|
          response.should have_tag('div[class*=?]', "report_#{category}_metrics") do
            @categories[category].each do |metric|
              with_tag('li', Regexp.new(Regexp.escape(metric.value.to_s)))
            end
          end
        end                
      end
    end
  end
end
