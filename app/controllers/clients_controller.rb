######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class ClientsController < ApplicationController
  # GET /clients/:client/:account/:currency
  def show
    setup
  end

  # POST clients/:client/:account/input_form
  def input_form
    setup
    render :partial => "input_form"
  end

  # POST clients/:client/:account/history
  def history
    setup
    render :partial => "history"
  end

  # POST /clients/
  def ack
    setup
    @event = Event.churn(:AcknowledgeFlow,
      "ack_password" => @account.password,
      "flow_specification" => params[:flow_spec],
      "declaring_account" => @account.omrl,
      "accepting_account" => params[:accepting_account],
      "currency" => params[:currency]
    )
    result = YAML.load(@event.result)
    summary = result[@account.omrl]    
    @account.update_summary_in_cache(params[:currency],summary)
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
    @currency_omrl ||= @account.default_currency if @account.default_currency?
    @currency_omrl ||= @currencies[0]
    @currency_omrl = @currency_omrl.chop if @currency_omrl =~ /\.$/
    @currency_spec = @account.currency_specification(@currency_omrl)
  end
  
end
