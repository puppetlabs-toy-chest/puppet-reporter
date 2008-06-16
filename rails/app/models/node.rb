class Node < ActiveRecord::Base
  def to_param
    name
  end
  
  def details
    {}
  end
end
