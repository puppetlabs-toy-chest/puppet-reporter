class Report < ActiveRecord::Base
  belongs_to :node
  validates_presence_of :node

  has_many :metrics

  validates_presence_of :timestamp
  validates_uniqueness_of :timestamp, :scope => :node_id
  
  validates_presence_of :details
  serialize :details
  
  has_many :logs
  
  def dtl_metrics
    details.metrics
  end

  def dtl_logs
    details.logs
  end
  
  # create Report instances from files containing Puppet YAML reports
  def self.import_from_yaml_files(filenames)
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
  def self.from_yaml(yaml)
    thawed = YAML.load(yaml)
    node = (Node.find_by_name(thawed.host) || Node.create!(:name => thawed.host))
    report = Report.create!(:details => yaml, :timestamp => thawed.time, :node => node)
    thawed.logs.each do |log|
      report.logs.create(:level => log.level.to_s, :message => log.message, :source => log.source, :timestamp => log.time, :tags => log.tags.collect(&:to_s).sort.join(', '))
    end
    report
  end
  
  class << self
    def between(start_time, end_time)
      find(:all, :conditions => ['timestamp >= ? and timestamp < ?', start_time, end_time])
    end
    
    def count_between(start_time, end_time)
      count(:conditions => ['timestamp >= ? and timestamp < ?', start_time, end_time])
    end
  end
end
