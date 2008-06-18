require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/reports/show" do
  before(:each) do
    @node = Node.generate!
    @report = @node.reports.generate!
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
    response.should have_tag('div[class=?][id=?]', 'report_details', 'report_details')
  end
  
  describe 'report details' do
  end
end
