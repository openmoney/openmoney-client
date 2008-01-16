class AddOmAccountCredentials < ActiveRecord::Migration
  def self.up
    add_column :om_accounts, :credentials, :text, :null => false
    accounts = OmAccount.find(:all)
    accounts.each do |a|
      a.credentials = {:tag => a.user.user_name, :password => a.password}.to_yaml
      a.save
    end
    remove_column :om_accounts, :password
  end

  def self.down
    add_column :om_accounts, :password, :string
    accounts = OmAccount.find(:all)
    accounts.each do |a|
      cred = YAML.load(a.credentials)
      a.password = cred[:password]
      a.save
    end
    remove_column :om_accounts, :credentials
  end
end