class Metric < ActiveRecord::Base
  belongs_to :report
  delegate :node, :to => :report
  
  validates_presence_of :report
  validates_presence_of :label
  validates_presence_of :value
  
  def self.from_puppet_metrics(report, metrics)
    metrics.keys.each do |category|
      metrics[category].values.each do |metric|
        Metric.create(:name => metric[0], :label => metric[1], :value => metric[2], :category => category)      
      end
    end
  end
end
