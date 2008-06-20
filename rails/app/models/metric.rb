class Metric < ActiveRecord::Base
  belongs_to :report
  delegate :node, :to => :report
  
  validates_presence_of :report
  validates_presence_of :label
  validates_presence_of :value
  
  def self.from_puppet_metrics(report, metrics)
    
  end
end
