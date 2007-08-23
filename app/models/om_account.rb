class OmAccount < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
  attr_protected :user_id
end
