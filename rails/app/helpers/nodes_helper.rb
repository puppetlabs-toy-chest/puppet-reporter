module NodesHelper
  
  def report_count_graph
    now = Time.zone.now
    data_points = Report.count_between(now - 1.day, now, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
  def node_report_count_graph(node)
    now = Time.zone.now
    data_points = node.reports.count_between(now - 1.day, now, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'discrete', :above_color => 'black', :height => 10)
  end
  
  def total_change_graph
    now = Time.zone.now
    data_points = Metric.total_changes_between(now - 1.day, now, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
  def node_total_change_graph(node)
    now = Time.zone.now
    data_points = node.metrics.total_changes_between(now - 1.day, now, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'discrete', :above_color => 'black', :height => 10)
  end
  
end
