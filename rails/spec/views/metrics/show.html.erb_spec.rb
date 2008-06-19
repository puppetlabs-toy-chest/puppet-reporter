require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/metrics/show.html.erb" do
  before :each do
    @report = Report.generate
    @metric = Metric.new(:report => @report, :label => 'test', :value => 42)
    assigns[:metric] = @metric
  end

  def do_render
    render '/metrics/show.html.erb'
  end

  it 'should include the metric label' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@metric.label)))
  end

  it 'should include the metric value' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@metric.value.to_s)))    
  end
  
  it 'should include a link to the report'
  
  it "should include the name of the report's node"
  
  it "should include a link to the report's node"
end
