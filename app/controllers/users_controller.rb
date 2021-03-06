######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class UsersController < ApplicationController
  require_authorization(:manage_users, :except => [:show,:update,:edit,:new,:create,:password]) 
  require_authentication(:except => [:new,:create])
  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if current_user_or_can?(:manage_users)
      @user = User.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id]) if current_user_or_can?(:manage_users)
    setup_return_to(:edit_profile_return_to)
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if logged_in? && current_user.can?(:manage_users) && params[:user][:role_id]
      @user.role_id = params[:user][:role_id]
    else
      # the first user is created as an admin...
      @user.role = Role.find_by_name(User.count == 0 ? 'admin' : 'user')
    end
    
    session[:rauth_after_login] = "/"
    respond_to do |format|
      if Rauth::Bridge.create_account(@user, :user_name => @user.user_name, :password => params[:password], :confirmation => params[:password_confirm])
        add_default_contexts(@user)
        add_default_account(@user)
        flash[:notice] = l('Your profile was created.')
        self.current_user = @user if !logged_in?
        format.html { redirect_to(home_url) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if current_user_or_can?(:manage_users)
      @user = User.find(params[:id])
      @user.role_id = params[:user][:role_id] if current_user.can?(:manage_users) #gotta do this because role is protected
      params[:user].delete(:role_id)
      @user.attributes = params[:user]
      respond_to do |format|
        return_url = session[:edit_profile_return_to] || users_url
        if @user.save
          flash[:notice] = l('Profile was updated.')
          format.html { redirect_to(return_url) }
          format.xml  { head :ok }
          session[:edit_profile_return_to] = nil
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    Rauth::Bridge.destroy_account(@user)
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  #GET /user/login_as
  def login_as
    @user = User.find(params[:id])
    self.current_user = @user
    respond_to do |format|
      format.html { render :action=>"show" }
      format.xml  { head :ok }
    end
  end
  
  # GET /users/1/password
  def password
    current_user_action do
      @require_current_password = current_password_required
      setup_return_to(:password_return_to)
    end
  end

  # PUT /users/1/set_password
  def set_password
    current_user_action do
      @require_current_password = current_password_required
      return_url = session[:password_return_to] || home_url
      respond_to do |format|
        @account = Rauth::Bridge.backend.find_by_user_name(@user.user_name)
        if @require_current_password
          changed_ok = @account.change_password(params[:current_password],params[:new_password],params[:password_confirm])
        else
          @account.password_with_confirmation(params[:new_password],params[:password_confirm])
          changed_ok = @account.valid?
        end
        if changed_ok && @account.save
          format.html { render :action => "password" }
          format.xml  { head :ok }
          session[:password_return_to] = nil
        else
          format.html { render :action => "password" }
          format.xml  { render :xml => @account.errors.to_xml }
        end
      end
    end
  end

  protected
  def current_user_action
    if current_user_or_can?(:manage_users)
      @user = User.find(params[:id])
      yield
    end
  end

  def current_password_required
    @user.id == current_user.id || !current_user.can?(:manage_users)
  end
 
  def add_default_contexts(user)
    def_contexts = Configuration.get(:default_namespaces).split(/[;\n]/)
    def_contexts.each do |x|
      x.gsub!(/ +/,'')
      if x =~ /(.*)\((.*),(.*)\)/
        context_name = $1
        tag = $2
        password = $3
        ctx = OmContext.new({:omrl => context_name})
        ctx.user_id = user.id
        ctx.credentials = {:tag => tag, :password=>password}.to_yaml
        ctx.save
      end
    end
  end
  
  def add_default_account(user)
    context = Configuration.get(:default_account_namespace)
    if context
      c = OmContext.find_by_omrl(context)
      if c
        name = user.user_name
        name.gsub!(/[^a-z0-9]/i,'')
        context_creds = YAML.load(c.credentials)
        entity_password = random_password
        act = OmAccount.new
        act.omrl = "#{name}.#{context}"
        act.user_id = user.id
        act.credentials = {:tag => name, :password => entity_password}.to_yaml
        spec = {"description" => params[:description]}
        acl = {:tag => name, :password => entity_password, :authorities => '*'}
        acl[:defaults] = ['accepts']
        event = Event.churn(:CreateAccount,
          "credentials" => {context => context_creds},
          "access_control" => acl,
          "parent_context" => context,
          "name" => name,
          "account_specification" => spec
        )
        if event.errors.empty?
          act.save
          currencies = Configuration.get(:default_account_currencies)
          if currencies
            currencies.gsub!(/ +/,'')
            currencies.split(/[\n;,]/).each do |currency|
              Event.churn(:JoinCurrency,"account" => act.omrl,"currency" => currency)
            end
          end
        end
      end
    end
  end 
end
