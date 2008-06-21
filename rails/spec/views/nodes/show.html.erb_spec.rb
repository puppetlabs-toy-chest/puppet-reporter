require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/show.html.erb' do
  before :each do
    @node = Node.generate!(:name => 'foo')
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

  describe 'if a node has failures' do
    before :each do
      @report  = @node.reports.generate!
      @failure = @report.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 3)
      @node.reload
    end
    
    it 'should include the node failures' do
      do_render
      response.should have_tag('ul[id=?]', 'failure_list')
    end
    
    it 'should include a list item for the failure' do
      do_render
      response.should have_tag('ul[id=?]', 'failure_list') do
        with_tag('li')
      end
    end
    
    it 'should include the failure count' do
      do_render
      response.should have_tag('ul[id=?]', 'failure_list') do
        with_tag('li', :text => Regexp.new(Regexp.escape(@failure.value.to_s)))
      end
    end
    
    it 'should include a link to the report' do
      do_render
      response.should have_tag('ul[id=?]', 'failure_list') do
        with_tag('li') do
          with_tag('a[href=?]', report_path(@report))
        end
      end
    end
    
    it 'should include the report time' do
      do_render
      response.should have_tag('ul[id=?]', 'failure_list') do
        with_tag('li', :text => Regexp.new(Regexp.escape(@report.timestamp.to_s)))
      end
    end
    
    it 'should include an item for every failure' do
      other_report  = @node.reports.generate!(:timestamp => Time.zone.now + 1235)
      other_failure = other_report.metrics.generate!(:category => 'resources', :label => 'Failed', :value => 3)
      @node.reload
      
      do_render
      response.should have_tag('ul[id=?]', 'failure_list') do
        [@report, other_report].each do |report|
          with_tag('li') do
            with_tag('a[href=?]', report_path(report))
          end
        end
      end
    end
  end

  describe 'if a node has no failures' do
    before :each do
      @node.stubs(:failures).returns([])
    end
    
    it 'should not include any failures' do
      do_render
      response.should_not have_tag('ul[id=?]', 'failure_list')
    end
  end
end
