require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/show.html.erb' do
  before :each do
    @node = Node.new(:name => 'foo')
    assigns[:node] = @node
  end

  def do_render
    render '/nodes/show.html.erb'
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
end