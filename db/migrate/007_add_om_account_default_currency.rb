class AddOmAccountDefaultCurrency < ActiveRecord::Migration
  def self.up
    add_column :om_accounts, :default_currency, :string, :null => false
  end

  def self.down
    remove_column :om_accounts, :default_currency
  end
end
