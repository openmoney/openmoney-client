######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmAccount < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id,:omrl
#TODO figure out why this doesn't work for accounts but works fine for currencies
#  validates_uniqueness_of :omrl
  attr_protected :user_id,:currencies_cache
  
  def currencies_list
    currencies.keys
  end
  
  def currency_specification(currency_omrl)
    c = currencies[currency_omrl]
    c.get_specification if c
  end
  
  def reload_currencies_cache
    currencies = Currency.find(:all, :params => { :used_by => self.omrl, "account_#{self.omrl}"=>'fish' })
    currencies_hash = {}
    currencies.each {|c| currencies_hash[c.omrl] = c}
    update_attribute(:currencies_cache,currencies_hash.to_yaml)
  end
  
#  def update_summary_in_cache(currency_omrl,summary)
#    c = YAML.load(self.currencies_cache)
#    c[currency_omrl].set_specification_attribute('summary',summary)
#    update_attribute(:currencies_cache,c.to_yaml)
#  end
  
  def currencies
    reload_currencies_cache if !self.currencies_cache?
    c = YAML.load(self.currencies_cache)
    c ||= {}
  end
  
  def before_save
    self.omrl = self.omrl.downcase
  end
end
