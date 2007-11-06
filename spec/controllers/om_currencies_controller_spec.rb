require File.dirname(__FILE__) + '/../spec_helper'

describe OmCurrenciesController, "#route_for" do

  it "should map { :controller => 'om_currencies', :action => 'index' } to /om_currencies" do
    route_for(:controller => "om_currencies", :action => "index").should == "/om_currencies"
  end
  
  it "should map { :controller => 'om_currencies', :action => 'new' } to /om_currencies/new" do
    route_for(:controller => "om_currencies", :action => "new").should == "/om_currencies/new"
  end
  
  it "should map { :controller => 'om_currencies', :action => 'show', :id => 1 } to /om_currencies/1" do
    route_for(:controller => "om_currencies", :action => "show", :id => 1).should == "/om_currencies/1"
  end
  
  it "should map { :controller => 'om_currencies', :action => 'edit', :id => 1 } to /om_currencies/1/edit" do
    route_for(:controller => "om_currencies", :action => "edit", :id => 1).should == "/om_currencies/1/edit"
  end
  
  it "should map { :controller => 'om_currencies', :action => 'update', :id => 1} to /om_currencies/1" do
    route_for(:controller => "om_currencies", :action => "update", :id => 1).should == "/om_currencies/1"
  end
  
  it "should map { :controller => 'om_currencies', :action => 'destroy', :id => 1} to /om_currencies/1" do
    route_for(:controller => "om_currencies", :action => "destroy", :id => 1).should == "/om_currencies/1"
  end
  
end

describe OmCurrenciesController, "#params_from" do

  it "should generate params { :controller => 'om_currencies', action => 'index' } from GET /om_currencies" do
    params_from(:get, "/om_currencies").should == {:controller => "om_currencies", :action => "index"}
  end
  
  it "should generate params { :controller => 'om_currencies', action => 'new' } from GET /om_currencies/new" do
    params_from(:get, "/om_currencies/new").should == {:controller => "om_currencies", :action => "new"}
  end
  
  it "should generate params { :controller => 'om_currencies', action => 'create' } from POST /om_currencies" do
    params_from(:post, "/om_currencies").should == {:controller => "om_currencies", :action => "create"}
  end
  
  it "should generate params { :controller => 'om_currencies', action => 'show', id => '1' } from GET /om_currencies/1" do
    params_from(:get, "/om_currencies/1").should == {:controller => "om_currencies", :action => "show", :id => "1"}
  end
  
  it "should generate params { :controller => 'om_currencies', action => 'edit', id => '1' } from GET /om_currencies/1;edit" do
    params_from(:get, "/om_currencies/1/edit").should == {:controller => "om_currencies", :action => "edit", :id => "1"}
  end
  
  it "should generate params { :controller => 'om_currencies', action => 'update', id => '1' } from PUT /om_currencies/1" do
    params_from(:put, "/om_currencies/1").should == {:controller => "om_currencies", :action => "update", :id => "1"}
  end
  
  it "should generate params { :controller => 'om_currencies', action => 'destroy', id => '1' } from DELETE /om_currencies/1" do
    params_from(:delete, "/om_currencies/1").should == {:controller => "om_currencies", :action => "destroy", :id => "1"}
  end
  
end

describe OmCurrenciesController, "handling GET /om_currencies" do

  before do
    @om_currency = mock_model(OmCurrency)
    OmCurrency.stub!(:find).and_return([@om_currency])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all om_currencies" do
    OmCurrency.should_receive(:find).with(:all).and_return([@om_currency])
    do_get
  end
  
  it "should assign the found om_currencies for the view" do
    do_get
    assigns[:om_currencies].should == [@om_currency]
  end
end

describe OmCurrenciesController, "handling GET /om_currencies.xml" do

  before do
    @om_currency = mock_model(OmCurrency, :to_xml => "XML")
    OmCurrency.stub!(:find).and_return(@om_currency)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all om_currencies" do
    OmCurrency.should_receive(:find).with(:all).and_return([@om_currency])
    do_get
  end
  
  it "should render the found om_currencies as xml" do
    @om_currency.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe OmCurrenciesController, "handling GET /om_currencies/1" do

  before do
    @om_currency = mock_model(OmCurrency)
    OmCurrency.stub!(:find).and_return(@om_currency)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the om_currency requested" do
    OmCurrency.should_receive(:find).with("1").and_return(@om_currency)
    do_get
  end
  
  it "should assign the found om_currency for the view" do
    do_get
    assigns[:om_currency].should equal(@om_currency)
  end
end

describe OmCurrenciesController, "handling GET /om_currencies/1.xml" do

  before do
    @om_currency = mock_model(OmCurrency, :to_xml => "XML")
    OmCurrency.stub!(:find).and_return(@om_currency)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the om_currency requested" do
    OmCurrency.should_receive(:find).with("1").and_return(@om_currency)
    do_get
  end
  
  it "should render the found om_currency as xml" do
    @om_currency.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe OmCurrenciesController, "handling GET /om_currencies/new" do

  before do
    @om_currency = mock_model(OmCurrency)
    OmCurrency.stub!(:new).and_return(@om_currency)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new om_currency" do
    OmCurrency.should_receive(:new).and_return(@om_currency)
    do_get
  end
  
  it "should not save the new om_currency" do
    @om_currency.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new om_currency for the view" do
    do_get
    assigns[:om_currency].should equal(@om_currency)
  end
end

describe OmCurrenciesController, "handling GET /om_currencies/1/edit" do

  before do
    @om_currency = mock_model(OmCurrency)
    OmCurrency.stub!(:find).and_return(@om_currency)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the om_currency requested" do
    OmCurrency.should_receive(:find).and_return(@om_currency)
    do_get
  end
  
  it "should assign the found OmCurrency for the view" do
    do_get
    assigns[:om_currency].should equal(@om_currency)
  end
end

describe OmCurrenciesController, "handling POST /om_currencies" do

  before do
    @om_currency = mock_model(OmCurrency, :to_param => "1")
    OmCurrency.stub!(:new).and_return(@om_currency)
  end
  
  def post_with_successful_save
    @om_currency.should_receive(:save).and_return(true)
    post :create, :om_currency => {}
  end
  
  def post_with_failed_save
    @om_currency.should_receive(:save).and_return(false)
    post :create, :om_currency => {}
  end
  
  it "should create a new om_currency" do
    OmCurrency.should_receive(:new).with({}).and_return(@om_currency)
    post_with_successful_save
  end

  it "should redirect to the new om_currency on successful save" do
    post_with_successful_save
    response.should redirect_to(om_currency_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe OmCurrenciesController, "handling PUT /om_currencies/1" do

  before do
    @om_currency = mock_model(OmCurrency, :to_param => "1")
    OmCurrency.stub!(:find).and_return(@om_currency)
  end
  
  def put_with_successful_update
    @om_currency.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @om_currency.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the om_currency requested" do
    OmCurrency.should_receive(:find).with("1").and_return(@om_currency)
    put_with_successful_update
  end

  it "should update the found om_currency" do
    put_with_successful_update
    assigns(:om_currency).should equal(@om_currency)
  end

  it "should assign the found om_currency for the view" do
    put_with_successful_update
    assigns(:om_currency).should equal(@om_currency)
  end

  it "should redirect to the om_currency on successful update" do
    put_with_successful_update
    response.should redirect_to(om_currency_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe OmCurrenciesController, "handling DELETE /om_currencies/1" do

  before do
    @om_currency = mock_model(OmCurrency, :destroy => true)
    OmCurrency.stub!(:find).and_return(@om_currency)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the om_currency requested" do
    OmCurrency.should_receive(:find).with("1").and_return(@om_currency)
    do_delete
  end
  
  it "should call destroy on the found om_currency" do
    @om_currency.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the om_currencies list" do
    do_delete
    response.should redirect_to(om_currencies_url)
  end
end
