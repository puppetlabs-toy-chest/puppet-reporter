class Metric < ActiveRecord::Base
  belongs_to :report
  
  validates_presence_of :report
  validates_presence_of :label
  validates_presence_of :value
end
