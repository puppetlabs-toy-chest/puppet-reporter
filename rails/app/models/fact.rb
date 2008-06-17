class Fact < ActiveRecord::Base
  belongs_to :node
  serialize :values
  
  before_save :default_timestamp_to_now
  before_save :default_values_to_empty
  
  def default_timestamp_to_now
    self.timestamp ||= Time.now
  end
  private :default_timestamp_to_now
  
  def default_values_to_empty
    self.values ||= {}
  end
  private :default_values_to_empty
end
