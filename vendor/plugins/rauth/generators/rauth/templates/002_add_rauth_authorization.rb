################################################################################
class AddRauthAuthorization < ActiveRecord::Migration
  ################################################################################
  def self.up
    create_table(:roles) do |t|
      t.column(:name,        :string)
      t.column(:description, :string)
    end

    create_table(:permissions) do |t|
      t.column(:name,        :string)
      t.column(:description, :string)
    end

    create_table(:allowances) do |t|
      t.column(:role_id,       :integer)
      t.column(:permission_id, :integer)
      t.column(:allowance,     :integer, :default => 1)
    end

    add_index(:roles, :name, :unique => true)
    add_index(:permissions, :name, :unique => true)
    add_index(:allowances, :role_id)
  end

  ################################################################################
  def self.down
    drop_table(:allowances)
    drop_table(:permissions)
    drop_table(:roles)
  end

end
################################################################################
