class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.text :description
      t.text :notes
      t.string :account_omrl
      t.string :currency_omrl
      t.integer :player_id
      t.integer :creator_id
      t.integer :project_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :plays
  end
end
