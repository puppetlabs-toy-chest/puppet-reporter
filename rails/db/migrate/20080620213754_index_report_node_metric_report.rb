class IndexReportNodeMetricReport < ActiveRecord::Migration
  def self.up
    add_index 'reports', 'node_id'
    add_index 'metrics', 'report_id'
  end

  def self.down
    remove_index 'metrics', 'report_id'
    remove_index 'reports', 'node_id'
  end
end
