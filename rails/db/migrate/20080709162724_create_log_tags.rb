class CreateLogTags < ActiveRecord::Migration
  def self.up
    create_table 'tags' do |t|
      t.string :name
    end
    
    create_table 'taggings' do |t|
      t.integer :tag_id, :log_id
    end
  end

  def self.down
    drop_table 'taggings'
    drop_table 'tags'
  end
end
