######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

SectionsOpenPlay = [{:name => 'projects', :url => '/nodes'},{:name => 'contributions', :url => '/plays'}]

class ApplicationController < ActionController::Base
  
  include L8n
            
  enable_authentication :user_model => 'User'
  enable_authorization
  require_authentication
  Rauth::Source::Native.rauth_options.update({
    :min_pass_length  => 4,
    :pass_error_msg   => 'Password must be at least 4 characters long',
    })

  def render_status(code)
    respond_to do |format| 
      format.html { render :file => "#{RAILS_ROOT}/public/#{code}.html", :status => code } 
      format.xml  { render :nothing => true, :status => code } 
    end 
    true 
  end
  
  # Creates options for find for index pages
  def search_options(search_name,field_map,order_map,default_fields,default_order,joins=nil,associations=nil)
    if !params[:search]
      # if the search params aren't in the actual params from the requst
      # then look for them in the session first, and if not there use the defaults
      if session[search_name]
  	    @search_params = session[search_name]
	    elsif default_fields
	      @search_params = default_fields
      end
      params[:search] = @search_params if @search_params
    else
      # otherwise use the search parameters and store them in the session for later
      @search_params = params[:search]
      session[search_name] = @search_params
    end
    if @search_params
      options = {}
    	if @search_params[:order]
    	  o = order_map[@search_params[:order]]
    	  options[:order] = o ? o : order_map[default_order]  		
      end
      conditions = add_conditions(conditions,field_map,@search_params[:on],@search_params[:for])
      @search_params.keys.each{|k| 
        conditions = add_conditions(conditions,field_map,$1,@search_params[k]) if k =~ /^on_(.*)/
      }
      options[:conditions] = conditions if conditions
      options[:joins] = joins if joins
      options[:include] = associations if associations
      options
    else
      nil
    end
	end
  		
	def add_conditions(conditions,field_map,field,value)
  	if field && field != ''
  	  (key,search_type,options) = field.split(/_/)
  	  skip = options =~ /n/ && (!value || value == '')
  	  field = field_map[key]
  	  if field && !skip
  	    case search_type
        when 'c'
          match = "#{field} like ?"; value = "%#{value}%"
        when 'b'
          match =  "#{field} like ?"; value = "#{value}%"
        else
          match =  "#{field} = ?"
        end
        if conditions
          conditions[0] = "#{conditions[0]} and #{match}"
          conditions <<  value
        else
          conditions = [match,value]
        end
      end
    end
    conditions
  end
  
  protected

  def setup_return_to(key)
    session[key] = request.env['HTTP_REFERER'] if !session[key]
  end
  
  def current_user_or_can?(permissions = nil,obj = nil)
    the_id = obj ? obj.user_id : params[:id].to_i
    permissions = [permissions] if !permissions.nil? && permissions.class != Array
    if (the_id == current_user.id) || (!permissions || (permissions.any? {|p| current_user.can?(p)} ) )
      true
    else
      respond_to do |format|
        flash[:notice] = 'Not allowed!'
        format.html { redirect_to( home_url) }
        format.xml  { head :failure }
      end
      false
    end
  end
  
  def setup_credentials_for_edit(entity)
    if params[:tag]
      @tag = params[:tag]
      @password = params[:password]
    else
      creds = YAML.load(entity.credentials)
      @password = creds[:password]
      @tag = creds[:tag]
    end
  end
  
  def random_password(size = 8)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end
  
  def handle_do_make(entity,entity_name,create_action,redirect_url,acl_defaults=nil)
    @entity_human_name = (entity_name == 'context') ? 'namespace' : entity_name
    @entity_tag = params[:tag]
    if params[:power_user]
      names = params[:omrl].split('.')
      name = names.shift
      context = names.join('.')
      context_creds = {:tag => params[:context_tag], :password => params[:context_password]}
      @entity_password = params[:password]
    else
      name = params[:name]
      if name !~ /^[-a-z0-9]+$/i
        @event = Event.new
        @event.errors.add("#{@entity_human_name} address" , 'must contiain only numbers, letters or hyphens')
        render :action => 'make'
        return
      end
      context = params[:parent_context]
      c = OmContext.find_by_omrl(context)
      context_creds = YAML.load(c.credentials)
      @entity_password = random_password
    end

    if context.nil? || context == "" || name.nil? || name == ""
      @event = Event.new
      @event.errors.add("#{@entity_human_name} address" , 'is missing or incomplete')
      render :action => 'make'
      return
    end

    entity.omrl = "#{name}.#{context}"
    entity.user_id = current_user.id
    entity.credentials = {:tag => @entity_tag, :password => @entity_password}.to_yaml

    if !entity.valid?
      render :action => 'make'
      return nil
    end
    
    spec = {"description" => params[:description]}
    spec = yield(spec) if block_given?
    acl = {:tag => @entity_tag, :password => @entity_password, :authorities => '*'}
    acl[:defaults] = acl_defaults if acl_defaults
    @event = Event.churn(create_action,
      "credentials" => {context => context_creds},
      "access_control" => acl,
      "parent_context" => context,
      "name" => name,
      "#{entity_name}_specification" => spec
    )
    
    if @event.errors.empty?
      entity.save
      redirect_to(redirect_url)
    else
      render :action => 'make'
    end
    
  end

end
