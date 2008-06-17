class Fact < ActiveRecord::Base
  belongs_to :node
  serialize :values
  
  before_save :default_timestamp_to_now
  
  def default_timestamp_to_now
    self.timestamp ||= Time.now
  end
  private :default_timestamp_to_now
end
