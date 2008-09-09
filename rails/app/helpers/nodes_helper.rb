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
    flot_graph(data_points, 'node_week_report_graph', 'week')
  end
  
  def node_month_report_graph(node, time = Time.zone.now)
    data_points = node.reports.count_between(time - 30.days, time, :interval => 1.day)
    flot_graph(data_points, 'node_month_report_graph', 'month')
  end
  
  def node_day_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_week_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 7.days, time, :interval => 1.day)
    flot_graph(data_points, 'node_week_failure_graph', 'week')
  end
  
  def node_month_failure_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_failures_between(time - 30.days, time, :interval => 1.day)
    flot_graph(data_points, 'node_month_failure_graph', 'month')
  end
  
  def node_day_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 1.day, time, :interval => 30.minutes)
    sparkline_tag(data_points, :type => 'smooth', :line_color => 'black', :height => 40)
  end
  
  def node_week_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 7.days, time, :interval => 1.day)
    flot_graph(data_points, 'node_week_resource_graph', 'week')
  end
  
  def node_month_resource_graph(node, time = Time.zone.now)
    data_points = node.metrics.total_resources_between(time - 30.days, time, :interval => 1.day)
    flot_graph(data_points, 'node_month_resource_graph', 'month')
  end
  
  
  private
  
  def flot_sparkline_options
    %q[
      {
        lines: { lineWidth: 1 },
        colors: ['black'],
        shadowSize: 0,
        grid: { borderWidth: 0 },
        xaxis: { ticks: [] },
        yaxis: { ticks: [] }
      };
    ]
  end
  
  def flot_graph(data_points, div_id, placeholder_class)
    div = %Q[<div id="#{div_id}" class="#{placeholder_class}_graph_placeholder"></div>]
    script = %Q[<script type="text/javascript">
      var graph_div = $('##{div_id}');
      var points = [#{data_points.flot_points.inspect}];
      var options = #{flot_sparkline_options}
      var plot = $.plot(graph_div, points, options)
    </script>]
    div + script
  end
  
end
