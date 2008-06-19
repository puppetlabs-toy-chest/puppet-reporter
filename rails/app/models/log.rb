class Log < ActiveRecord::Base
  belongs_to :report
  validates_presence_of :report
  delegate :node, :to => :report
  
  validates_presence_of :level
  validates_presence_of :message
  validates_presence_of :timestamp
end
