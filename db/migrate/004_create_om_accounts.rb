class CreateOmAccounts < ActiveRecord::Migration
  def self.up
    create_table :om_accounts do |t|
      t.integer :user_id
      t.string :omrl
      t.string :password
      t.text :currencies_cache

      t.timestamps 
    end
  end

  def self.down
    drop_table :om_accounts
  end
end
