require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/metrics/show" do
  before :each do
    @report = Report.generate
    @metric = Metric.new(:report => @report, :label => 'test', :value => 42)
    assigns[:metric] = @metric
  end

  def do_render
    render '/metrics/show'
  end

  it 'should include the metric label' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@metric.label)))
  end

  it 'should include the metric value' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@metric.value.to_s)))    
  end
  
  it 'should include a link to the report' do
    do_render
    response.should have_tag('a[href=?]', report_path(@report))
  end
  
  it 'should include the time of the report' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@report.timestamp.to_s)))
  end
  
  it "should include the name of the report's node" do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@report.node.name)))
  end
  
  it "should include a link to the report's node" do
    do_render
    response.should have_tag('a[href=?]', node_path(@report.node))
  end
end
