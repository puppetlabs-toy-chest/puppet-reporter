class Fact < ActiveRecord::Base
  belongs_to :node
  serialize :values
end
