class CreateFacts < ActiveRecord::Migration
  def self.up
    create_table :facts do |t|
      t.integer   :node_id
      t.text      :values
      t.timestamp :timestamp
      t.timestamps
    end
  end

  def self.down
    drop_table :facts
  end
end
