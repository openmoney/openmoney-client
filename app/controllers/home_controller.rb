######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class HomeController < ApplicationController
  require_authentication(:except => [:index])
  def index
#    redirect_to({:controller => 'clients', :action => 'show', :client => current_user.user_name}) if logged_in? && !current_user.om_accounts.empty?
  end
end
