class AddCategoryToMetrics < ActiveRecord::Migration
  def self.up
    add_column :metrics, :category, :string
  end

  def self.down
    remove_column :metrics, :category
  end
end
