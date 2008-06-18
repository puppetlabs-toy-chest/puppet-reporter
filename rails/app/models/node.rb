class Node < ActiveRecord::Base
  has_many :facts
  has_many :reports
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # allow controllers to look up and link to Nodes by name
  def to_param
    name
  end

  # get a hash of Node details, via Facts
  def details(timestamp = Time.zone.now)
    facts = most_recent_facts_on(timestamp)
    facts ? facts.values : {}
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
end
