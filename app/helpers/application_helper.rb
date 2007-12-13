######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

require "lib/om_classes"

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include L8n
  
  def acknowledge_flows_url(account_omrl)
    "/clients/#{current_user.user_name}/#{account_omrl}"
  end
end
