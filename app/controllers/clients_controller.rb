class ClientsController < ApplicationController
  # GET /clients/:client/:account/:currency
  def show
    setup_currency
  end

  # POST clients/:client/:account/input_form
  def input_form
    setup_currency
    render :partial => "input_form"
  end

  # POST clients/:client/:account/history
  def history
    setup_currency
    render :partial => "history"
  end

  # POST /clients/
  def ack
  end
  
  def setup_currency
    @currency_omrl = params[:currency]
    @currency_omrl ||= 'bucks^us'
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
