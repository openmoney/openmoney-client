class DefaultRoles < ActiveRecord::Migration
  def self.up
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
