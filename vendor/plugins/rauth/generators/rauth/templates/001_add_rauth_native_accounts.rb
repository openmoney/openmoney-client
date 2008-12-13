################################################################################
class AddRauthNativeAccounts < ActiveRecord::Migration
  ################################################################################
  def self.up
    create_table(:rauth_native_accounts) do |t|
      t.column(:user_name,        :string)
      t.column(:openid_url,       :string)
      t.column(:password_salt,    :string)
      t.column(:password_hash,    :string)
      t.column(:activation_code,  :string)
      t.column(:reset_code,       :string)
      t.column(:created_at,       :datetime)
      t.column(:enabled,          :boolean, :default => true)
    end

    add_index(:rauth_native_accounts, :user_name, :unique => true)
    add_index(:rauth_native_accounts, :activation_code)
    add_index(:rauth_native_accounts, :reset_code)
  end

  ################################################################################
  def self.down
    drop_table(:rauth_native_accounts)
  end

end
################################################################################
