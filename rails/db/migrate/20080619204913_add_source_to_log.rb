class AddSourceToLog < ActiveRecord::Migration
  def self.up
    add_column 'logs', 'source', :string
  end

  def self.down
    remove_column 'logs', 'source'
  end
end
