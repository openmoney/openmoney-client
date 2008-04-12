class AddHomePageConfigurations < ActiveRecord::Migration
  def self.up
    txt = <<EOHTML
    <p>
    This site is for you to eXplore &amp; eXperiment with creating open money namespaces, accounts and currencies.
    </p>
    <p>
    Many, many features are yet to be implemented - however what's here is sufficient to demonstrate the basic architecture and functionality of open money systems.
    </p>
EOHTML
    c = Configuration.new(:name => 'home_page_public',:configuration_type=>'text', :value => txt,
      :notes => 'html to display on home page if no user is logged in'
      )
    c.save
    txt = <<EOHTML
    <p>
    This site is for you to eXplore &amp; eXperiment with creating open money namespaces, accounts and currencies.
    </p>
    <p>
    Many, many features are yet to be implemented - however what's here is sufficient to demonstrate the basic architecture and functionality of open money systems.
    </p>


    <div id="getting-started">
    Now that you have created a user profile, here's what you can do:

    <ul>
      <li>
    	<a href="/om_accounts">name new accounts</a> (as many as you like) in the ".x" namespace, i.e. - <code>henry.x</code>, <code>mytown.x</code>, <code>31419.x</code>, etc. When you create accounts you set the credentials for the account which you can give to others to access it.
    	</li>
      <li>
    	<a href="/join_currency">join your accounts to currencies</a> (whose names you know)
    	</li>
      <li>
    		<a href="/clients">record flows</a> to, and receive flows from other accounts (whose names you know)
    	</li>
      <li>
    	<a href="/om_currencies">name new currencies</a>  (as many as you like) in the ".x" namespace, i.e. - <code>cc.x</code>, <code>game1.x</code>, etc.  When you create a currency you can set its properties using the templates provided (more to come) or directly in the currency specification language.  You also set the credentials for the currency which you can give to others to access it.
    	</li>
      <li>
    	<a href="/om_contexts">open new namespaces</a> i.e. - <code>town.x</code>, <code>me.x</code> <br />
    	Once you open a new namespace you can then start  all over and:
    	<p class="indented_1">
    	name accounts in them  - <code>henry.town.x</code> <br />
    	name currencies / systems  - <code>cc.town.x</code> <br />
    	open new namespaces - <code>south.town.x</code>  <br />
    	</p>
     <p class="indented_2">
    	name accounts in them  - <code>pete.south.town.x</code> <br />
    	name currencies / systems  - <code>youth.south.town.x</code> <br />
    	open new namespaces - <code>bus.south.town</code> <br />
    	</p>
    	and so on, 
    	</p>
    	</li>
    </ul>
     </div>
EOHTML

    c = Configuration.new(:name => 'home_page_logged_in',:configuration_type=>'text',
      :value => txt,
      :notes => 'html to display on home page when a user is logged in.'
      )
    c.save
  end

  def self.down
    Configuration.find_by_name('home_page_public').destroy
    Configuration.find_by_name('home_page_logged_in').destroy
  end
end
