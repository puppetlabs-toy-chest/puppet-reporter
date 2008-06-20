module NodesHelper
  
  def report_count_graph
    now = Time.zone.now
    data_points = Report.count_between(now - 1.day, now, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
end
