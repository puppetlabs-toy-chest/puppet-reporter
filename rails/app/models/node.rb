class Node < ActiveRecord::Base
  def to_param
    name
  end
  
  def details(timestamp = Time.now)
    most_recent_facts_on(timestamp)
  end
  
  def most_recent_facts_on(timestamp)
    {}
  end
end
