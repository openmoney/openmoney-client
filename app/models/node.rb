class Node < ActiveRecord::Base
  belongs_to :modifier, :class_name => "User", :foreign_key => "modifier_id"
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  belongs_to :om_account
  has_many :plays, :foreign_key => "project_id", :dependent => :nullify
  acts_as_nested_set

  def get_account
    return om_account if om_account
    return nil if parent.nil?
    return parent.get_account
  end
  
  def long_name
    (self.ancestors.collect{|n| n.name} << self.name).join('|')
  end
end
