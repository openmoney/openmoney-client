class DefaultRoles < ActiveRecord::Migration
  def self.up
    role = Role.create(:name => 'admin')
    role.save!
    role = Role.create(:name => 'user')
    role.save!
  end

  def self.down
  end
end
