class Log < ActiveRecord::Base
  belongs_to :report
  validates_presence_of :report
  delegate :node, :to => :report
  
  validates_presence_of :level
  validates_presence_of :message
  validates_presence_of :timestamp
  
  has_many :taggings
  has_many :tags, :through => :taggings
  
  def tag_names
    tags.collect(&:name).sort.join(', ')
  end
  
  def tag_names=(val)
    val.split(', ').each do |name|
      taggings.build(:tag => Tag.find_or_create_by_name(name))
    end
  end
  
  class << self
    def from_puppet_logs(logs)
      logs.each do |log|
        tag_names = (log.tags || []).collect(&:to_s).sort.join(', ')
        Log.create(:level => log.level.to_s, :message => log.message, :source => log.source, :timestamp => log.time, :tag_names => tag_names)
      end
    end
    
    def recent
      find(:all, :conditions => ['timestamp >= ?', Time.zone.now - 30.minutes], :limit => 5, :order => 'timestamp desc')
    end
    
    def latest
      find(:all, :order => 'timestamp desc', :limit => 5)
    end
  end
end
