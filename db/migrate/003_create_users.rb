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

      t.timestamps 
    end
  end

  def self.down
    drop_table :users
  end
end
