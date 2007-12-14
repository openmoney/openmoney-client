ActionController::Routing::Routes.draw do |map|
  map.resources :om_currencies, :new => {:make => :get,:do_make => :post}

  map.resources :om_accounts, :member => {:join => :get,:do_join => :post},:new => {:make => :get,:do_make => :post}

  # Named routes
  map.home('', :controller => 'home', :action => 'index')

  map.resources :users, :member => {
    :login_as => :get,
    :password => :get, :set_password => :put
    }

  # The priority is based upon order of creation: first created -> highest priority.

  ####################################################################################
  #rauth routes
  map.resources(:sessions)
  map.login('/login',   :controller => 'sessions', :action => 'new')
  map.logout('/logout', :controller => 'sessions', :action => 'destroy')


  ####################################################################################
  # Routes for the rubycc
  account_regex = /[^\/]*/
  currency_regex = /[^\/]*/
  #TODO at some point accounts and currency portions of the URLs should have a real regexp match intstead of /.*/ (which is currently there because periods are not valid by default)
  map.connect 'clients/:client/:account/input_form', :controller => 'clients', :action => 'input_form',:conditions => {:method => :post}, :requirements => { :account =>account_regex }
  map.connect 'clients/:client/:account/history', :controller => 'clients', :action => 'history',:conditions => {:method => :post}, :requirements => { :account =>account_regex }
  map.connect 'clients/:client/:account/:currency', :controller => 'clients', :action => 'show',:conditions => {:method => :get}, :defaults => { :account => nil, :currency => nil }, :requirements => { :account => account_regex, :currency => currency_regex }
  map.connect 'clients/:client/:account/:currency', :controller => 'clients', :action => 'ack',:conditions => {:method => :post}, :requirements => { :account => account_regex, :currency => currency_regex }

  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
