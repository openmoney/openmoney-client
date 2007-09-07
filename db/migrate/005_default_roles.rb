class DefaultRoles < ActiveRecord::Migration
  def self.up
    role = Role.create(:name => 'admin')
    role.save!
    role = Role.create(:name => 'user')
    role.save!
  end
  [:manage_users].each{|p| Permission.create(:name => p)}

  def self.down
  end
end
