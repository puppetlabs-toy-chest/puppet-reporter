module NodesHelper
  
  def report_count_graph
    now = Time.zone.now
    start_time = now - 1.day
    end_time = start_time + 30.minutes
    
    data_points = []
    while end_time <= now
      data_points.push Report.count_between(start_time, end_time)
      
      start_time = end_time
      end_time += 30.minutes
    end
    
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
end
