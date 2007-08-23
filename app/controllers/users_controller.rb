class UsersController < ApplicationController
  require_authorization(:manage_users, :except => [:show,:update,:edit]) 
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
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if params[:user][:role_id]
      @user.role_id = params[:user][:role_id]
    else
      @user.role_id = Role.find_by_name('user').id
    end
    
    session[:rauth_after_login] = "/"
    respond_to do |format|
      if Rauth::Bridge.create_account(@user, :user_name => @user.username, :password => params[:password], :confirmation => params[:password_confirm])
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
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
      respond_to do |format|
        if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully updated.'
          format.html { redirect_to(@user) }
          format.xml  { head :ok }
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
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
end
