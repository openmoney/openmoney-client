######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class ClientsController < ApplicationController
  # GET /clients/:client/:account/:currency
  def show
    setup
    get_summary      
  end

  # POST clients/:client/:account/input_form
  def input_form
    setup
    render :partial => "input_form"
  end

  # POST clients/:client/:account/history
  def history
    setup
    get_summary
    render :partial => "history"
  end

  # POST /clients/
  def ack
    setup
    @event = Event.churn(:AcknowledgeFlow,
      "credentials" => {@account.omrl => YAML.load(@account.credentials)},
      "flow_specification" => params[:flow_spec],
      "flow_uid" => params[:flow_uid],
      "declaring_account" => @account.omrl,
      "accepting_account" => params[:accepting_account],
      "currency" => @currency_omrl
    )
    if @event.errors.empty?
      result = YAML.load(@event.result)
      @summary = result['summary'][@account.omrl]
    else
      get_summary
    end
    render :partial => "history"
  end
  
  protected
  def setup
    u = current_user    
    @params = {"declaring_account" => params[:declaring_account],"accepting_account" => params[:accepting_account]}
    @params.merge!(params[:flow_spec]) if params[:flow_spec]

    @client = params[:client]
    @account_omrl = params[:account]
    @accounts = u.om_accounts
    if !@accounts.empty?
      @account_omrl ||= u.pref_default_account if u.pref_default_account?
      @account_omrl ||= @accounts[0].omrl 
    end
    
    @account = u.om_accounts.find_by_omrl(@account_omrl)
    raise "unconfigured account #{@account_omrl}" if !@account
    
    @currencies = @account.currencies_list

    @currency_omrl = params[:currency]
    @currency_omrl ||= @account.default_currency if @account.default_currency? && @account.currency_specification(@account.default_currency)
    @currency_omrl ||= @currencies[0]
    @currency_spec = @account.currency_specification(@currency_omrl)
  end
  
  def get_summary
    s = Currency.get_summaries(@currency_omrl,@account_omrl)
    @summary = s[@account_omrl] if s
  end
  
  
end
