require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NodesHelper do
  
  it 'should create a report count graph' do
    helper.should respond_to(:report_count_graph)
  end
  
  describe 'creating a report count graph' do
    before :each do
      helper.stubs(:sparkline_tag)
      Report.stubs(:count_between)
    end
    
    it 'should create a sparkline' do
      helper.expects(:sparkline_tag)
      helper.report_count_graph
    end
    
    it 'should get report count data' do
      Report.expects(:count_between).at_least_once
      helper.report_count_graph
    end
    
    it 'should create a sparkline using the report count data' do
      now = Time.zone.now
      Time.zone.stubs(:now).returns(now)
      
      start_time = now - 1.day
      end_time = start_time + 30.minutes
      
      data_points = []
      while end_time <= now
        data_point = stub("data point #{end_time}")
        Report.stubs(:count_between).with(start_time, end_time).returns(data_point)
        data_points.push data_point
        
        start_time = end_time
        end_time += 30.minutes
      end
      
      helper.expects(:sparkline_tag).with(data_points, anything)
      helper.report_count_graph
    end
    
    it 'should create a smooth sparkline' do
      helper.expects(:sparkline_tag).with(anything, has_entry(:type => 'smooth'))
      helper.report_count_graph
    end
    
    it 'should return the sparkline tag' do
      sparkline = stub('sparkline')
      helper.stubs(:sparkline_tag).returns(sparkline)
      helper.report_count_graph.should == sparkline
    end
  end

end
