class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :logs, :through => :taggings
  
  class << self
    def with_counts
      tags = find(:all,
                  :joins  => 'left outer join taggings on taggings.tag_id = tags.id',
                  :group  => 'taggings.tag_id',
                  :select => 'tags.*, count(taggings.tag_id) as count',
                  :order  => 'count desc')
      tags.each { |t|  t.count = t.count.to_i }
      tags
    end
  end
end
