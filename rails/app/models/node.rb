class Node < ActiveRecord::Base
  has_many :facts
  
  def to_param
    name
  end
  
  def details(timestamp = Time.now)
    most_recent_facts_on(timestamp)
  end
  
  def most_recent_facts_on(timestamp)
    facts
    {}
  end
end
