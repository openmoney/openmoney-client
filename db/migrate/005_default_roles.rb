class DefaultRoles < ActiveRecord::Migration
  def self.up
    require 'rauth/permission'
    require 'rauth/role'
    require 'rauth/allowance'
    ['manage_users'].each{|p| Permission.create(:name => p)}
    role = Role.create(:name => 'admin')
    role.save!
    role.allowances.add('manage_users')
    role = Role.create(:name => 'user')
    role.save!


  end

  def self.down
  end
end
