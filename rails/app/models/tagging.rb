class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :log
end
