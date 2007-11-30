######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmCurrenciesController < ApplicationController
  include OpenMoneyHelper
  # GET /om_currencies
  # GET /om_currencies.xml
  def index
    @om_currencies = current_user.om_currencies
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @om_currencies }
    end
  end

  # GET /om_currencies/1
  # GET /om_currencies/1.xml
  def show
    @om_currency = OmCurrency.find(params[:id])
    if current_user_or_can?(:manage_users,@om_currency)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @om_currency }
      end
    end
  end

  # GET /om_currencies/new
  # GET /om_currencies/new.xml
  def new
    @om_currency = OmCurrency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @om_currency }
    end
  end

  # GET /om_currencies/1/edit
  def edit
    @om_currency = OmCurrency.find(params[:id])
    current_user_or_can?(:manage_users,@om_currency)
    setup_return_to(:edit_currencies_return_to)
    creds = YAML.load(@om_currency.credentials)
    @password = creds[:password]
    @tag = creds[:tag]
  end

  # POST /om_currencies
  # POST /om_currencies.xml
  def create
    @om_currency = OmCurrency.new(params[:om_currency])
    @om_currency.user_id = current_user.id
    @om_currency.credentials = {:tag => params[:tag], :password => params[:password]}.to_yaml

    begin
      c = Currency.find(@om_currency.omrl)
    rescue Exception => e
      @om_currency.errors.add(:omrl, "currency could not be accessed (#{e.to_s})")
    end

    respond_to do |format|
      if c && @om_currency.save
        flash[:notice] = 'Currency was successfully accessed.'
        format.html { redirect_to(om_currencies_url) }
        format.xml  { render :xml => @om_currency, :status => :created, :location => @om_currency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @om_currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /om_currencies/1
  # PUT /om_currencies/1.xml
  def update
    @om_currency = OmCurrency.find(params[:id])
    if current_user_or_can?(:manage_users,@om_currency)
      
      @om_currency.attributes = params[:om_currency]
      respond_to do |format|
        return_url = session[:edit_currency_return_to] || om_currencies_url
        if @om_currency.save
          flash[:notice] = 'Currency was successfully updated.'
          format.html { redirect_to(return_url) }
          format.xml  { head :ok }
          session[:edit_currency_return_to] = nil
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @om_currency.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /om_currencies/1
  # DELETE /om_currencies/1.xml
  def destroy
    @om_currency = OmCurrency.find(params[:id])
    if current_user_or_can?(:manage_users,@om_currency)
      @om_currency.destroy

      respond_to do |format|
        format.html { redirect_to(om_currencies_url) }
        format.xml  { head :ok }
      end
    end
  end

  def make
  end
  
  def do_make
    (name,context) = params[:omrl].split('~')
    if context.nil? || context == "" || name.nil? || name == ""
      @event = Event.new
      @event.errors.add(:currency_address, 'is missing or incomplete')
      render :action => 'make'
      return
    end

    @om_currency = OmCurrency.new()
    @om_currency.omrl = params[:omrl]
    @om_currency.user_id = current_user.id
    
    @om_currency.credentials = {:tag => params[:currency_tag], :password => params[:currency_password]}.to_yaml

    if !@om_currency.valid?
      render :action => 'make'
      return
    end
    
    currency_spec = {
      "description" => params[:description]
    }
    if params[:use_advanced]
      currency_spec.merge!(YAML.load(params[:currency_spec]))
    else
      case params[:type]
      when "mutual_credit"
        currency_spec = default_mutual_credit_currency(params[:use_description],params[:use_taxable],params[:unit])
      when "reputation"
        currency_spec = default_reputation_currency(params[:rating_type])
    	end  
    end
        
    @event = Event.churn(:CreateCurrency,
      "credentials" => {context => {:tag => params[:context_tag], :password => params[:context_password]}},
      "access_control" => {:tag => params[:currency_tag], :password => params[:currency_password], :authorities => '*', :defaults=>['approves','is_used_by']},
      "parent_context" => context,
      "name" => name,
      "currency_specification" => currency_spec
    )
    
    if @event.errors.empty?
      @om_currency.save
      redirect_to(om_currencies_url)
    else
      render :action => 'make'
    end
  end

end
