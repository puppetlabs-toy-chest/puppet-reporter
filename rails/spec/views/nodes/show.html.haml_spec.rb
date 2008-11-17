require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/show' do
  before :each do
    @node = Node.generate!(:name => 'foo')
    assigns[:node] = @node
    template.stubs(:node_day_report_graph).returns('node day report graph goes here')
    template.stubs(:node_week_report_graph).returns('node week report graph goes here')
    template.stubs(:node_month_report_graph).returns('node month report graph goes here')
    template.stubs(:node_day_failure_graph).returns('node day failure graph goes here')
    template.stubs(:node_week_failure_graph).returns('node week failure graph goes here')
    template.stubs(:node_month_failure_graph).returns('node month failure graph goes here')
    template.stubs(:node_day_resource_graph).returns('node day resource graph goes here')
    template.stubs(:node_week_resource_graph).returns('node week resource graph goes here')
    template.stubs(:node_month_resource_graph).returns('node month resource graph goes here')
    template.stubs(:render)
    @now = Time.zone.now
    Time.zone.stubs(:now).returns(@now)
  end

  def do_render
    render '/nodes/show'
  end

  it 'should include the name of the Node' do
    do_render
    response.should have_text(Regexp.new(@node.name))
  end

  it 'should look up details for the node' do
    @node.expects(:details).returns({})
    do_render
  end

  it 'should render node details' do
    template.expects(:render).with {|args| args[:partial] == 'facts' }
    do_render
  end

  describe 'if node has no reports' do
    before :each do
      assigns[:most_recent_report] = nil
    end
    
    it 'should indicate that the node has never reported in' do
      do_render
      response.should have_text(/Never/)
    end
  end

  describe 'if node has a most recent report' do
    before :each do
      @time = Time.now
      @report = @node.reports.generate(:timestamp => @time)
      assigns[:most_recent_report] = @report
    end
    
    it 'should display the most recent node report time' do
      do_render
      response.should have_text(Regexp.new(@report.timestamp.to_s))
    end

    it 'should link node report time to the associated node report' do
      do_render
      response.should have_tag('a[href=?]', report_path(@report))
    end  
  end

  it 'should include graphs' do
    do_render
    response.should have_tag('table[id=?]', 'node_graphs')
  end
  
  describe 'node graphs' do
    it 'should include a day report graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node day report graph goes here')))
    end
    
    it 'should get a day report graph for the node' do
      template.expects(:node_day_report_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the day report graph off now' do
      template.expects(:node_day_report_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a week report graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node week report graph goes here')))
    end
    
    it 'should get a week report graph for the node' do
      template.expects(:node_week_report_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the week report graph off now' do
      template.expects(:node_week_report_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a month report graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node month report graph goes here')))
    end
    
    it 'should get a month report graph for the node' do
      template.expects(:node_month_report_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the month report graph off now' do
      template.expects(:node_month_report_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a day failure graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node day failure graph goes here')))
    end
    
    it 'should get a day failure graph for the node' do
      template.expects(:node_day_failure_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the day failure graph off now' do
      template.expects(:node_day_failure_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a week failure graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node week failure graph goes here')))
    end
    
    it 'should get a week failure graph for the node' do
      template.expects(:node_week_failure_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the week failure graph off now' do
      template.expects(:node_week_failure_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a month failure graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node month failure graph goes here')))
    end
    
    it 'should get a month failure graph for the node' do
      template.expects(:node_month_failure_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the month failure graph off now' do
      template.expects(:node_month_failure_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a day resource graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node day resource graph goes here')))
    end
    
    it 'should get a day resource graph for the node' do
      template.expects(:node_day_resource_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the day resource graph off now' do
      template.expects(:node_day_resource_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a week resource graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node week resource graph goes here')))
    end
    
    it 'should get a week resource graph for the node' do
      template.expects(:node_week_resource_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the week resource graph off now' do
      template.expects(:node_week_resource_graph).with(anything, @now)
      do_render
    end
    
    it 'should include a month resource graph' do
      do_render
      response.should have_tag('table[id=?]', 'node_graphs', :text => Regexp.new(Regexp.escape('node month resource graph goes here')))
    end
    
    it 'should get a month resource graph for the node' do
      template.expects(:node_month_resource_graph).with(@node, anything)
      do_render
    end
    
    it 'should base the month resource graph off now' do
      template.expects(:node_month_resource_graph).with(anything, @now)
      do_render
    end
  end
end
