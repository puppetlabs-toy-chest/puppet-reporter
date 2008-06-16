class Node < ActiveRecord::Base
  def to_param
    name
  end
  
  def details(timestamp = Time.now)
    { :operatingsystem => 'Darwin' }
  end
end
