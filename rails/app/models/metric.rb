class Metric < ActiveRecord::Base
  belongs_to :report
  delegate :node, :to => :report
  
  validates_presence_of :report
  validates_presence_of :label
  validates_presence_of :value
  
  def value
    if val = attributes['value']
      if %w[changes resources].include?(category)
        val.to_i
      else
        val.to_f
      end
    end
  end
  
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
          
          metrics = find(:all, { :conditions => ['reports.timestamp >= ? and reports.timestamp < ? and category = ? and label = ?', start_time, end_time, '#{data[:category]}', '#{data[:label]}'] }.merge(find_options))
          
          if interval = options[:interval]
            # getting rid of usec
            start_time = Time.parse(start_time.to_s)
            end_time   = Time.parse(end_time.to_s)
            
            partitioned_metrics = Hash.new { |h, k| h[k] = [] }
            partitions = (start_time..end_time).partitions(interval)
            
            metrics.each do |metric|
              partition = partitions.detect { |part|  (part.first...part.last).include?(metric.report.timestamp) }
              
              partitioned_metrics[partition].push metric
            end
            
            partitions.collect do |part|
              partitioned_metrics[part].collect(&:value).inject(&:+) || 0
            end
          else
            metrics.collect(&:value).inject(&:+) || 0
          end
        end
      end_of_eval
    end
    
    {
      :changes   => { :category => 'changes',   :label => 'Total' },
      :failures  => { :category => 'resources', :label => 'Failed' },
      :resources => { :category => 'resources', :label => 'Total' }
    }.each do |type, data|
      define_time_interval_method(type, data)
    end
    
    def failures(include_zero = false)
      conditions = ['category = ? and label = ?', 'resources', 'Failed']
      conditions[0] += ' and value > 0' unless include_zero 
      find(:all, :conditions => conditions)
    end
  end
end
