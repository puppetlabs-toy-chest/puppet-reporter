module NodesHelper
  
  def report_count_graph(time = Time.zone.now)
    data_points = Report.count_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
  def node_report_count_graph(node, time = Time.zone.now)
    data_points = node.reports.count_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'discrete', :above_color => 'black', :below_color => 'lightgray', :upper => 1, :height => 10)
  end
  
  def total_change_graph(time = Time.zone.now)
    data_points = Metric.total_changes_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
  def node_total_change_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_changes_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 10)
  end
  
  def total_failure_graph(time = Time.zone.now)
    data_points = Metric.total_failures_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
  def node_total_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 10)
  end
  
  def total_resource_graph(time = Time.zone.now)
    data_points = Metric.total_resources_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 20)
  end
  
  def node_total_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 10)
  end
  
  def node_day_report_graph(node, time = Time.zone.now)
    data_points = node.reports.count_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_week_report_graph(node, time = Time.zone.now)
    data_points = node.reports.count_between(time - 7.days, time, :interval => 1.day)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_month_report_graph(node, time = Time.zone.now)
    data_points = node.reports.count_between(time - 30.days, time, :interval => 1.day)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_day_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_week_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 7.days, time, :interval => 1.day)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_month_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 30.days, time, :interval => 1.day)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_day_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_week_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 7.days, time, :interval => 1.day)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_month_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 30.days, time, :interval => 1.day)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
end
