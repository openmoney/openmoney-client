class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :name
      t.text :body
      t.integer :om_account_id
      t.integer :modifier_id
      t.integer :owner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
