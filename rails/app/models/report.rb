class Report < ActiveRecord::Base
  belongs_to :node
  validates_presence_of :node

  has_many :metrics
  delegate :failures, :to => :metrics
  
  validates_presence_of :timestamp
  validates_uniqueness_of :timestamp, :scope => :node_id
  
  validates_presence_of :details
  serialize :details
  
  has_many :logs
  
  after_create  :freshen_node_facts
  
  def freshen_node_facts
    node.refresh_facts
  rescue Exception => e
    true
  end
  private :freshen_node_facts
  
  
  class << self

    # create Report instances from files containing Puppet YAML reports
    def import_from_yaml_files(filenames)
      good, bad = [], []
      filenames.each do |file|
        begin
          Report.from_yaml File.read(file)
          good << file
        rescue SystemCallError => e
          warn "Could not read file [#{file}]: #{e}"
          bad << file
        rescue Exception => e
          warn "There was an error processing file [#{file}]: #{e}"
          bad << file
        end
      end
      [ good, bad ]
    end
  
    # create a single Report instance from a Puppet report YAML string
    def from_yaml(yaml)
      thawed = YAML.load(yaml)
      node = (Node.find_by_name(thawed.host) || Node.create!(:name => thawed.host))
      report = Report.create!(:details => yaml, :timestamp => thawed.time, :node => node)
      report.logs.from_puppet_logs(thawed.logs)
      report.metrics.from_puppet_metrics(thawed.metrics)
      report
    end
    
    def between(start_time, end_time, options = {})
      reports = find(:all, :conditions => ['timestamp >= ? and timestamp < ?', start_time, end_time])
      
      if interval = options[:interval]
        # getting rid of usec
        start_time = Time.parse(start_time.to_s)
        end_time   = Time.parse(end_time.to_s)
        
        partitioned_reports = Hash.new { |h, k| h[k] = [] }
        partitions = (start_time..end_time).partitions(interval)
        
        reports.each do |report|
          partition = partitions.detect { |part|  (part.first...part.last).include?(report.timestamp) }
          
          partitioned_reports[partition].push report
        end
        
        partitioned_reports.values_at(*partitions)
      else
        reports
      end
    end
    
    def count_between(start_time, end_time, options = {})
      quoted_start = connection.quote(start_time)
      quoted_end   = connection.quote(end_time)
      reports = find_by_sql("select timestamp from reports where timestamp >= #{quoted_start} and timestamp < #{quoted_end}")
      
      if interval = options[:interval]
        # getting rid of usec
        start_time = Time.parse(start_time.to_s)
        end_time   = Time.parse(end_time.to_s)
        
        partitioned_counts = Hash.new(0)
        partitions = (start_time..end_time).partitions(interval)
        
        reports.each do |report|
          partition = partitions.detect { |part|  (part.first...part.last).include?(report.timestamp) }
          
          partitioned_counts[partition] += 1
        end
        
        partitioned_counts.values_at(*partitions)
      else
        reports.length
      end
    end
  end
end
