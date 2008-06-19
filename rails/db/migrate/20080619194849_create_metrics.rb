class CreateMetrics < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.string :label, :name
      t.float :value
      t.integer :report_id
      t.timestamps
    end
  end

  def self.down
    drop_table :metrics
  end
end
