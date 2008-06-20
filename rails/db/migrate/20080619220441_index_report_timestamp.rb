class IndexReportTimestamp < ActiveRecord::Migration
  def self.up
    add_index 'reports', 'timestamp'
  end

  def self.down
    remove_index 'reports', 'timestamp'
  end
end
