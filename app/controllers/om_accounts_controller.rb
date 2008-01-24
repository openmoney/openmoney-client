######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmAccountsController < ApplicationController
  # GET /om_accounts
  # GET /om_accounts.xml
  def index
    @om_accounts = current_user.om_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @om_accounts }
    end
  end

  # GET /om_accounts/1
  # GET /om_accounts/1.xml
  def show
    @om_account = OmAccount.find(params[:id])
    if current_user_or_can?(:manage_users,@om_account)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @om_account }
      end
    end
  end

  # GET /om_accounts/new
  # GET /om_accounts/new.xml
  def new
    @om_account = OmAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @om_account }
    end
  end

  # GET /om_accounts/1/edit
  def edit
    @om_account = OmAccount.find(params[:id])
    current_user_or_can?(:manage_users,@om_account)
    setup_return_to(:edit_account_return_to)
    setup_credentials_for_edit(@om_account)
  end

  # POST /om_accounts
  # POST /om_accounts.xml
  def create
    @om_account = OmAccount.new(params[:om_account])
    @om_account.user_id = current_user.id
    @om_account.credentials = {:tag => params[:tag], :password => params[:password]}.to_yaml

    respond_to do |format|
      if @om_account.save
        flash[:notice] = 'account was successfully accessed.'
        format.html { redirect_to(om_accounts_url) }
        format.xml  { render :xml => @om_account, :status => :created, :location => @om_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @om_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /om_accounts/1
  # PUT /om_accounts/1.xml
  def update
    @om_account = OmAccount.find(params[:id])
    if current_user_or_can?(:manage_users,@om_account)
      @om_account.currencies_cache = nil if params[:clear_currencies_cache]
      @om_account.attributes = params[:om_account]
      respond_to do |format|
        return_url = session[:edit_account_return_to] || om_accounts_url
        if @om_account.save
          flash[:notice] = 'account was successfully updated.'
          format.html { redirect_to(return_url) }
          format.xml  { head :ok }
          session[:edit_account_return_to] = nil
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @om_account.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /om_accounts/1
  # DELETE /om_accounts/1.xml
  def destroy
    @om_account = OmAccount.find(params[:id])
    if current_user_or_can?(:manage_users,@om_account)
      @om_account.destroy

      respond_to do |format|
        format.html { redirect_to(om_accounts_url) }
        format.xml  { head :ok }
      end
    end
  end
  
  def join
    @om_account = OmAccount.find(params[:id])
  end
  
  def do_join
    @om_account = OmAccount.find(params[:id])
    @event = Event.churn(:JoinCurrency,"account" => @om_account.omrl,"currency" => params[:currency])
    
    if @event.errors.empty?
      @om_account.update_attribute(:currencies_cache,nil)
      redirect_to(om_accounts_url)
    else
      render :action => 'join'
    end
  end

  def make
  end
  
  def do_make
    @om_account = OmAccount.new()
    handle_do_make(@om_account,'account',:CreateAccount,om_accounts_url,['accepts'])
  end

  def account_omrls_select
    render :partial => 'account_omrls_select', :locals => { :id => params[:id] }
  end
  
end
