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
      #TODO.  The specification should be cached in om_currency just as we do for accounts
      @summary_form = YAML.load(Currency.find_by_omrl(@om_currency.omrl).specification)['summary_form']
      @summaries = Currency.get_summaries(@om_currency.omrl)
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
    setup_credentials_for_edit(@om_currency)
  end

  # POST /om_currencies
  # POST /om_currencies.xml
  def create
    @om_currency = OmCurrency.new(params[:om_currency])
    @om_currency.user_id = current_user.id
    @om_currency.credentials = {:tag => params[:tag], :password => params[:password]}.to_yaml

    begin
      c = Currency.find_by_omrl(@om_currency.omrl)
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
    @om_currency = OmCurrency.new()
    handle_do_make(@om_currency,'currency',:CreateCurrency,om_currencies_url,['approves','is_used_by']) do |spec|
      if params[:use_advanced]
        spec.merge!(YAML.load(params[:currency_spec]))
      else
        case params[:type]
        when "mutual_credit"
          spec = default_mutual_credit_currency(params[:use_description],params[:use_taxable],params[:unit])
        when "reputation"
          spec = default_reputation_currency(params[:rating_type])
      	end  
      end
      spec
    end
  end

end
