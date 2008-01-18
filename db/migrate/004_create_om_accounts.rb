class CreateOmAccounts < ActiveRecord::Migration
  def self.up
    create_table :om_accounts do |t|
      t.integer :user_id
      t.string :omrl
      t.text :credentials, :null => false
      t.text :currencies_cache
      t.string :default_currency,  :null => false

      t.timestamps 
    end
  end

  def self.down
    drop_table :om_accounts
  end
end
