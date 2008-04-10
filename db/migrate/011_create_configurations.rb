class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :name
      t.string :configuration_type
      t.text :value
      t.text :notes

      t.timestamps
    end
    c = Configuration.new(:name => 'server',:configuration_type=>'string',:value => 'http://localhost:3001',
      :notes => 'URL that points to the server this client talks to.'
      )
    c.save
    c = Configuration.new(:name => 'default_namespaces',:configuration_type=>'text',:value => 'x(steward,fish)',
      :notes => 'list of namespaces(with id and password) to auto add to all users'
      )
    c.save
    c = Configuration.new(:name => 'show_weal',:configuration_type=>'options(yes,no)',:value => 'no',
      :notes => 'activates the weal/sfa interface'
      )    
    c.save
    c = Configuration.new(:name => 'welcome',:configuration_type=>'text',:value => 'Welcome to open money!',
      :notes => 'welcome header to show on the home page'
      )
    c.save
  end

  def self.down
    drop_table :configurations
  end
end
