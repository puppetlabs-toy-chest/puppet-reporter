class Metric < ActiveRecord::Base
  belongs_to :report
  delegate :node, :to => :report
  
  validates_presence_of :report
  validates_presence_of :label
  validates_presence_of :value
  
  def self.from_puppet_metrics(report, metrics)
    metric_items = metrics.keys.inject([]) {|list, key| list += metrics[key].values }
    metric_items.each do |metric|
      report.metrics.create!(:name => metric[0], :label => metric[1], :value => metric[2])      
    end
  end
end
