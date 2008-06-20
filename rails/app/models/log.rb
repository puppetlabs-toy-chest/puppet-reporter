class Log < ActiveRecord::Base
  belongs_to :report
  validates_presence_of :report
  delegate :node, :to => :report
  
  validates_presence_of :level
  validates_presence_of :message
  validates_presence_of :timestamp
  
  class << self
    def from_puppet_logs(logs)
      logs.each do |log|
        Log.create(:level => log.level.to_s, :message => log.message, :source => log.source, :timestamp => log.time, :tags => log.tags.collect(&:to_s).sort.join(', '))
      end
    end
  end
end
