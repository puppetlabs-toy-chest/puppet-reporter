class Metric < ActiveRecord::Base
  belongs_to :report
  delegate :node, :to => :report
  
  validates_presence_of :report
  validates_presence_of :label
  validates_presence_of :value
  
  class << self
    def from_puppet_metrics(metrics)
      metrics.keys.each do |category|
        metrics[category].values.each do |metric|
          Metric.create(:name => metric[0], :label => metric[1], :value => metric[2], :category => category)      
        end
      end
    end
    
    def categorize(metrics)
      metrics.inject({}) {|h, m| h[m.category] ||= []; h[m.category] << m; h}
    end
  end
end
