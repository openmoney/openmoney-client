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
  end

  # POST /om_accounts
  # POST /om_accounts.xml
  def create
    @om_account = OmAccount.new(params[:om_account])
    @om_account.user_id = current_user.id

    respond_to do |format|
      if @om_account.save
        flash[:notice] = 'OmAccount was successfully created.'
        format.html { redirect_to(@om_account) }
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

      respond_to do |format|
        if @om_account.update_attributes(params[:om_account])
          flash[:notice] = 'OmAccount was successfully updated.'
          format.html { redirect_to(@om_account) }
          format.xml  { head :ok }
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
end
