######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmAccount < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
  attr_protected :user_id
  
  def reload_currencies_cache
    currencies = Currency.find(:all, :params => { :used_by => self.omrl })
    currencies_list = currencies.collect {|c| c.omrl.chop}
    update_attribute(:currencies_cache,currencies_list.to_yaml)
    currencies_list
  end
end
