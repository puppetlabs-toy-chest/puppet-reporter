require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reports/show" do
  before(:each) do
    @node = Node.generate!
    @report = @node.reports.generate!
    @log = stub('log', :level => 'log level', :message => 'log message', :source => 'log source', :timestamp => Time.zone.now, :tag_names => '')
    @report.stubs(:logs).returns([@log])
    @metrics = { }
    assigns[:report] = @report
    template.stub_render(:partial => 'logs/log', :collection => [@log])
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
    
    it 'should include log information' do
      template.expect_render(:partial => 'logs/log', :collection => [@log])
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
