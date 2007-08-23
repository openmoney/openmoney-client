######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class User < ActiveRecord::Base
  belongs_to_role
  has_many :om_accounts, :dependent => :destroy
  attr_protected :role_id
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  public 
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def login_action
    update_attribute(:last_login,Time.now)
  end
end
