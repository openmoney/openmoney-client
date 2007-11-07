#############################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmCurrency < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
  validates_uniqueness_of :omrl
  attr_protected :user_id
end
