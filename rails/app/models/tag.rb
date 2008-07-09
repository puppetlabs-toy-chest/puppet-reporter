class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :logs, :through => :taggings
end
