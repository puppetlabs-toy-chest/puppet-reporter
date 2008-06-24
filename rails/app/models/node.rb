class Node < ActiveRecord::Base
  has_many :facts
  has_many :reports
  has_many :logs, :through => :reports
  has_many :metrics, :through => :reports
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # allow controllers to look up and link to Nodes by name
  def to_param
    CGI.escape(name).gsub('.', '%2E')
  end

  # get a hash of Node details, via Facts
  def details(timestamp = Time.zone.now)
    facts = most_recent_facts_on(timestamp)
    facts ? facts.values.values : {}
  end
  
  # find the most recent Fact instance at the specified timestamp
  def most_recent_facts_on(timestamp)
    facts.find(:first, :conditions => ['timestamp < ?', timestamp], :order => 'timestamp desc')
  end
  
  # find the most recent Report instance at the specified timestamp
  def most_recent_report_on(timestamp)
    reports.find(:first, :conditions => ['timestamp < ?', timestamp], :order => 'timestamp desc')
  end
  
  # pull new Facts for this node from the source
  def refresh_facts
    fact = Fact.refresh_for_node(self)
    facts << fact
    fact
  end
  
  def failures(include_zero = false)
    reports.find(:all, :limit => 200, :order => 'timestamp desc').collect { |rep| rep.failures(include_zero) }.flatten.sort_by { |f|  f.report.timestamp }.reverse
  end
end
