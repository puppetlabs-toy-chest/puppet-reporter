class Log < ActiveRecord::Base
  belongs_to :report
  validates_presence_of :report
  delegate :node, :to => :report
  
  validates_presence_of :level
  validates_presence_of :message
  validates_presence_of :timestamp
  
  has_many :taggings
  has_many :tags, :through => :taggings
  
  class << self
    def from_puppet_logs(logs)
      logs.each do |log|
        tags = (log.tags || []).collect(&:to_s).sort.join(', ')
        Log.create(:level => log.level.to_s, :message => log.message, :source => log.source, :timestamp => log.time, :tags => tags)
      end
    end
  end
end
