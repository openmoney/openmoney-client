class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :account_id
      t.integer :role_id
      t.string :user_name
      t.string :email
      t.string :first_name
      t.string :last_name
      t.datetime :last_login
      t.string :pref_language, :null => false, :default => ''
      t.integer :pref_items_per_page, :null => false, :default => 20
      t.string :pref_default_account, :null => false, :default => ''

      t.timestamps 
    end
  end

  def self.down
    drop_table :users
  end
end
