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
    
    def self.define_time_interval_method(type, data)
      class_eval <<-end_of_eval
        def total_#{type}_between(start_time, end_time, options = {})
          find_options = {}
          find_options[:include] = :report unless ((scope(:find) || {})[:joins] || '').match(/reports\.id/)
          
          if interval = options[:interval]
            metrics = []
            low_time = start_time
            high_time = low_time + interval
            
            while high_time <= end_time
              metrics.push find(:all, { :conditions => ['reports.timestamp >= ? and reports.timestamp < ? and category = ? and label = ?', low_time, high_time, '#{data[:category]}', '#{data[:label]}'] }.merge(find_options))
              
              low_time   = high_time
              high_time += interval
              if high_time > end_time
                high_time = end_time unless low_time == end_time
              end
            end
            
            metrics.collect { |met|  met.collect(&:value).inject(&:+) || 0 }
          else
            metrics = find(:all, { :conditions => ['reports.timestamp >= ? and reports.timestamp < ? and category = ? and label = ?', start_time, end_time, '#{data[:category]}', '#{data[:label]}'] }.merge(find_options))
            metrics.collect(&:value).inject(&:+) || 0
          end
        end
      end_of_eval
    end
    
    {
      :changes  => { :category => 'changes',   :label => 'Total' },
      :failures => { :category => 'resources', :label => 'Failed' }
    }.each do |type, data|
      define_time_interval_method(type, data)
    end
  end
end
