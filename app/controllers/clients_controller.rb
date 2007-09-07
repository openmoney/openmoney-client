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
    account = current_user.om_account(params[:account])
    raise "unconfigured account #{params[:account]}" if !account
    @event = Event.new(
     {:event_type => "AcknowledgeFlow",
      :specification => {
        "ack_password" => account.password,
        "flow_specification" => params[:flow_spec],
        "declaring_account" => account.omrl,
        "accepting_account" => params[:accepting_account],
        "currency" => params[:currency]
       }.to_yaml
     }
    )
    @event.save
    if @event.respond_to?(:error)
      @event_error = @event.error
    end

    render :partial => "history"
  end
  
  def setup
    u = current_user
    @currency_omrl = params[:currency]
    @currency_omrl ||= u.pref_default_currency if u.pref_default_currency?
    @currency_omrl ||= 'bucks~us'  #TODO take out this bogus default!
    @currency_omrl = @currency_omrl.chop if @currency_omrl =~ /\.$/
    @currency = Entity.find(@currency_omrl)
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
    if @account.currencies_cache? && !params[:reload_currencies_cache]
      @currencies = YAML.load(@account.currencies_cache)
    else
      @currencies = @account.reload_currencies_cache
    end
  end
  
end
