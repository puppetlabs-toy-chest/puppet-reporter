class CreateLogModel < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer   :report_id
      t.string    :level
      t.string    :message
      t.string    :tags
      t.timestamp :timestamp
    end
  end

  def self.down
    drop_table :logs
  end
end
