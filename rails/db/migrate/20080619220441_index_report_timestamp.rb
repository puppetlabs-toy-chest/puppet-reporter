class IndexReportTimestamp < ActiveRecord::Migration
  def self.up
    add_index 'reports', 'timestamp'
  end

  def self.down
    drop_index 'reports', 'timestamp'
  end
end
