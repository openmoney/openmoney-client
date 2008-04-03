class AddDateFormatPref < ActiveRecord::Migration
  def self.up
    add_column :users, :pref_date_format, :string, :default=>"", :null=>false
  end

  def self.down
    remove_column :users, :pref_date_format
  end
end
