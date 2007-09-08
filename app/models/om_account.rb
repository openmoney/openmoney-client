######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmAccount < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
  attr_protected :user_id,:currencies_cache
  
  def currencies_list
    currencies.keys
  end
  
  def currency_specification(currency_omrl)
    c = currencies[currency_omrl]
    c.get_specification if c
  end
  
  def reload_currencies_cache
    currencies = Currency.find(:all, :params => { :used_by => self.omrl })
    currencies_hash = {}
    currencies.each {|c| currencies_hash[c.omrl.chop] = c}
    update_attribute(:currencies_cache,currencies_hash.to_yaml)
  end
  
  def currencies
    reload_currencies_cache if !self.currencies_cache?
    c = YAML.load(self.currencies_cache)
    c ||= {}
  end
end
