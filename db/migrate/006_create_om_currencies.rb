class CreateOmCurrencies < ActiveRecord::Migration
  def self.up
    create_table :om_currencies do |t|
      t.integer :user_id
      t.string :omrl
      t.text :credentials

      t.timestamps 
    end
  end

  def self.down
    drop_table :om_currencies
  end
end
