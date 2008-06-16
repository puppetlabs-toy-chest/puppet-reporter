class Node < ActiveRecord::Base
  def to_param
    name
  end
  
  def details
    { :operatingsystem => 'Darwin' }
  end
end
