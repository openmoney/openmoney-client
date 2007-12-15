class OmContext < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
  validates_uniqueness_of :omrl, :scope => [:user_id]
  attr_protected :user_id
end
