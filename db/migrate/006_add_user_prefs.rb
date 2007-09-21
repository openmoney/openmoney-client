class AddUserPrefs < ActiveRecord::Migration
  def self.up
    add_column :users, :pref_language, :string, :null => false
    add_column :users, :pref_items_per_page, :integer, :null => false, :default => 20
    add_column :users, :pref_default_account, :string, :null => false
  end

  def self.down
    remove_column :users, :pref_language
    remove_column :users, :pref_items_per_page
    remove_column :users, :pref_default_account
  end
end
