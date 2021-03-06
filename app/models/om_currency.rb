######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmCurrency < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
  validates_uniqueness_of :omrl, :scope => [:user_id], :message => 'has already been accessed'
  validates_format_of :omrl, :with => /\A((?:[-a-z0-9]+\.)+[a-z]{1,})\Z/i, :message => 'must contain only numbers, letters, or hyphens'
  attr_protected :user_id

  HUMANIZED_ATTRIBUTES = {
    :omrl => "Currency address"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def before_save
    self.omrl = self.omrl.downcase
  end
end
