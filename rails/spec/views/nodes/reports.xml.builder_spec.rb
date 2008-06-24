require File.dirname(__FILE__) + '/../../spec_helper'
require 'hpricot'

describe "/nodes/reports.xml.builder" do
  def do_render
    render "/nodes/reports.xml.builder"
    @doc = Hpricot.XML(response.body.to_s)
  end
  
  before :each do
    @reports = [ Report.generate(:timestamp => 1.week.ago), 
                 Report.generate(:timestamp => 3.days.ago), 
                 Report.generate(:timestamp => 1.day.ago)
               ]
    assigns[:reports] = @reports
  end
  
  it 'should have a data container element' do
    do_render
    (@doc/:data).first.should_not be_nil
  end
  
  describe 'top-level data element' do
    it 'should have event elements for every report' do
      do_render
      (@doc/:data/:event).size.should == @reports.size
    end
  end
  
  describe 'event elements' do
    it "should specify a start time in Timeplot's very specific format" do
      do_render
      (@doc/:data/:event).each_with_index do |report,i|
        report["start"].should == @reports[i].timestamp.strftime("%b %d %Y %H:%M:%S GMT-0500")
      end
    end
    
    it 'should use the correct time zone when generating Timeplot timestamps (currently hardwired to GMT-0500)'
    
    it 'should have a link to the report' do
      do_render
      (@doc/:data/:event).each_with_index do |report,i|
        report["link"].should == report_path(@reports[i])
      end      
    end
  end
end