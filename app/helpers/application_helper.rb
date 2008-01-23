######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

require "lib/om_classes"

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include L8n
  
  require 'parsedate'
  
  def users_select(f,id)
    f.collection_select(id, User.find(:all, :order => "last_name,first_name"), :id, :full_name)
  end
  
  def standard_date(date)
    if date.is_a?(String)
      d = ParseDate.parsedate(date)
      date = Date.new(*d[0..2]) if d[0]
    end
    if date
      "#{date.month}/#{date.day}/#{date.year}" 
    else
      ""
    end
  end

  def standard_time(time)
    if time.is_a?(String)
      t = ParseDate.parsedate(date)
      time = Time.local(*t) if t[0]
    end
    if time
      time.asctime 
    else
      ""
    end
  end
  
  def acknowledge_flows_url(account_omrl)
    "/clients/#{current_user.user_name}/#{account_omrl}"
  end
  
  def om_contexts_select(html_field_name,selected=nil)
    c = OmContext.find(:all,:conditions => ['user_id = ?',current_user.id]).collect{|e| e.omrl}
    return nil if c.empty?
    select_tag(html_field_name,options_for_select(c,selected))
  end
  
  def make_entity_base_fields(entity_type,default_omrl='',default_tag='steward')
    context_select = om_contexts_select(:parent_context,params[:parent_context])
    result = ""
    detailed = <<-EOHTML
  	  <b>Credential for parent context access:</b><br />
  	  ID: #{text_field_tag(:context_tag,params[:context_tag] || 'steward')} Password: #{password_field_tag :context_password,params[:context_password]}
  	<br />
    <b>#{entity_type} omrl:</b> #{ text_field_tag :omrl,params[:omrl]||default_omrl}
    EOHTML
    if context_select
      name_and_context = <<-EOHTML
      <p id="power" style="display: none">
      #{detailed}
      </p>
      <p id="easy">
      <b>#{entity_type} Name: </b> #{ text_field_tag :name,params[:name] } in #{context_select}
      </p>
      
      EOHTML
      power = %Q|(<input id="power_user" type="checkbox" name="power_user" value="1" onClick="if($F('power_user')) {$('easy').hide();$('power').show()} else {$('easy').show();$('power').hide()}" #{params[:power_user] ? 'checked' : ''} > detailed)|
    else
      name_and_context = detailed
      power = %Q|<input id="power_user" type="hidden" name="power_user" value="1">|
    end
     <<-EOHTML
   	<fieldset style="display: inline">
   		<legend>#{entity_type} Info #{power}</legend>
   		#{name_and_context}
    <p>
      <b>Description:</b><br />
      #{ text_field_tag :description,params[:description] ,:size => 50 }
    </p>

    <p>
      <b>Access Credentials For New #{entity_type}:</b><br />
      ID: #{text_field_tag :tag,params[:tag] || default_tag }
      Password: #{password_field_tag :password,params[:password] }
    </p>
    </fieldset>
    EOHTML
    
  end
end
