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
    @password = YAML.load(@om_currency.credentials)[:password]
  end

  # POST /om_currencies
  # POST /om_currencies.xml
  def create
    @om_currency = OmCurrency.new(params[:om_currency])
    @om_currency.user_id = current_user.id
    @om_currency.credentials = {:tag => current_user.user_name, :password => params[:password]}.to_yaml

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
    @om_currency.credentials = {:tag => current_user.user_name, :password => params[:currency_password]}.to_yaml

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
        currency_spec = default_mutual_credit_currency(params[:taxable],params[:unit])
      when "reputation"
        r = { 'type' => 'integer',
          'description' => {
            'en' => 'Rate',
            'es' => 'Califique'
          }
        }
        r['values_enum'] = {
      		"2qual" => {
            'en' => [['Good',1],['Bad',2]],
            'es' => [['Bueno',1],['Malo',2]],
          },
      		"2yesno" => {
      		  'en' => [['Yes',2],['No',1]],
      		  'es' => [['Si',2],['No',1]],
      		},
      		"3qual" => {
      		  'en' => [['Good',3],['Average',2],['Bad',1]],
      		  'es' => [['Bueno',3],['Mediano',2],['Malo',1]],
      		},
      		"4qual" => {
      		  'en' => [['Excellent',4],['Good',3],['Average',2],['Bad',1]],
      		  'es' => [['Excellente',4],['Bueno',3],['Mediano',2],['Malo',1]],
      		},
      		"3stars" => [['***',3],['**',2],['*',1]],
      		"4stars" => [['****',4],['***',3],['**',2],['*',1]],
      		"5stars" => [['*****',5],['****',4],['***',3],['**',2],['*',1]],
      		"3" => (1..3).to_a,
      		"4" => (1..4).to_a,
      		"5" => (1..5).to_a,
      		"10" => (1..10).to_a
          }[params[:rating_type]]
          
        r['type'] = 'integer'
        r['description'] = {
            'en' => 'Rating',
            'es' => 'Calificacíon'
          }
    
        currency_spec['fields'] = {
        	'rate' => {
            'type' => 'submit',
            
        	},
          'rating' => r,
        }
      	currency_spec['summary_type'] = 'mean(rating)'
      	currency_spec['input_form'] = {
      	  'en' => ":declaring_account rates :accepting_account as :rating :rate",
      	  'es' => ":declaring_account califica :accepting_account como :rating :rate"
      	}
      	currency_spec['summary_form'] = {
      	  'en' => ":Overall rating: :mean_accepted (from :count_accepted total ratings)",
          'es' => "Calificacíon: :mean_accepted (de :count_accepted calificacíones)"
      	}        
    	end  
    end
    
    @event = Event.churn(:CreateCurrency,
      "credentials" => {context => {:tag => current_user.user_name, :password=>params[:context_password]}},
      "access_control" => {:tag => current_user.user_name, :password=>params[:currency_password]},
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
