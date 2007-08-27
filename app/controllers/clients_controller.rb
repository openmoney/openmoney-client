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
    render :partial => "history"
  end
  
  def setup
    @currency_omrl = params[:currency]
    @currency_omrl ||= 'bucks~us'  #TODO take out this bogus default!
    @currency_omrl = @currency_omrl.chop if @currency_omrl =~ /\.$/
    @currency = Entity.find(@currency_omrl)
    @params = {"declaring_account" => params[:declaring_account],"accepting_account" => params[:accepting_account]}
    @params.merge!(params[:flow_spec]) if params[:flow_spec]

    @client = params[:client]
    @account = params[:account]
    @accounts = current_user.om_accounts
    @account ||= @accounts[0].omrl if !@accounts.empty?
    
    currencies = Currency.find(:all, :params => { :used_by => @account })
    @currencies = currencies.collect {|c| c.omrl}
  end
  
end
