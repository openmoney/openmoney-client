require File.dirname(__FILE__) + '/../spec_helper'

describe OmAccountsController, "#route_for" do

  it "should map { :controller => 'om_accounts', :action => 'index' } to /om_accounts" do
    route_for(:controller => "om_accounts", :action => "index").should == "/om_accounts"
  end
  
  it "should map { :controller => 'om_accounts', :action => 'new' } to /om_accounts/new" do
    route_for(:controller => "om_accounts", :action => "new").should == "/om_accounts/new"
  end
  
  it "should map { :controller => 'om_accounts', :action => 'show', :id => 1 } to /om_accounts/1" do
    route_for(:controller => "om_accounts", :action => "show", :id => 1).should == "/om_accounts/1"
  end
  
  it "should map { :controller => 'om_accounts', :action => 'edit', :id => 1 } to /om_accounts/1/edit" do
    route_for(:controller => "om_accounts", :action => "edit", :id => 1).should == "/om_accounts/1/edit"
  end
  
  it "should map { :controller => 'om_accounts', :action => 'update', :id => 1} to /om_accounts/1" do
    route_for(:controller => "om_accounts", :action => "update", :id => 1).should == "/om_accounts/1"
  end
  
  it "should map { :controller => 'om_accounts', :action => 'destroy', :id => 1} to /om_accounts/1" do
    route_for(:controller => "om_accounts", :action => "destroy", :id => 1).should == "/om_accounts/1"
  end
  
end

describe OmAccountsController, "handling GET /om_accounts" do

  before do
    @om_account = mock_model(OmAccount)
    OmAccount.stub!(:find).and_return([@om_account])
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
  
  it "should find all om_accounts" do
    OmAccount.should_receive(:find).with(:all).and_return([@om_account])
    do_get
  end
  
  it "should assign the found om_accounts for the view" do
    do_get
    assigns[:om_accounts].should == [@om_account]
  end
end

describe OmAccountsController, "handling GET /om_accounts.xml" do

  before do
    @om_account = mock_model(OmAccount, :to_xml => "XML")
    OmAccount.stub!(:find).and_return(@om_account)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all om_accounts" do
    OmAccount.should_receive(:find).with(:all).and_return([@om_account])
    do_get
  end
  
  it "should render the found om_accounts as xml" do
    @om_account.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe OmAccountsController, "handling GET /om_accounts/1" do

  before do
    @om_account = mock_model(OmAccount)
    OmAccount.stub!(:find).and_return(@om_account)
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
  
  it "should find the om_account requested" do
    OmAccount.should_receive(:find).with("1").and_return(@om_account)
    do_get
  end
  
  it "should assign the found om_account for the view" do
    do_get
    assigns[:om_account].should equal(@om_account)
  end
end

describe OmAccountsController, "handling GET /om_accounts/1.xml" do

  before do
    @om_account = mock_model(OmAccount, :to_xml => "XML")
    OmAccount.stub!(:find).and_return(@om_account)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the om_account requested" do
    OmAccount.should_receive(:find).with("1").and_return(@om_account)
    do_get
  end
  
  it "should render the found om_account as xml" do
    @om_account.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe OmAccountsController, "handling GET /om_accounts/new" do

  before do
    @om_account = mock_model(OmAccount)
    OmAccount.stub!(:new).and_return(@om_account)
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
  
  it "should create an new om_account" do
    OmAccount.should_receive(:new).and_return(@om_account)
    do_get
  end
  
  it "should not save the new om_account" do
    @om_account.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new om_account for the view" do
    do_get
    assigns[:om_account].should equal(@om_account)
  end
end

describe OmAccountsController, "handling GET /om_accounts/1/edit" do

  before do
    @om_account = mock_model(OmAccount)
    OmAccount.stub!(:find).and_return(@om_account)
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
  
  it "should find the om_account requested" do
    OmAccount.should_receive(:find).and_return(@om_account)
    do_get
  end
  
  it "should assign the found OmAccount for the view" do
    do_get
    assigns[:om_account].should equal(@om_account)
  end
end

describe OmAccountsController, "handling POST /om_accounts" do

  before do
    @om_account = mock_model(OmAccount, :to_param => "1")
    OmAccount.stub!(:new).and_return(@om_account)
  end
  
  def post_with_successful_save
    @om_account.should_receive(:save).and_return(true)
    post :create, :om_account => {}
  end
  
  def post_with_failed_save
    @om_account.should_receive(:save).and_return(false)
    post :create, :om_account => {}
  end
  
  it "should create a new om_account" do
    OmAccount.should_receive(:new).with({}).and_return(@om_account)
    post_with_successful_save
  end

  it "should redirect to the new om_account on successful save" do
    post_with_successful_save
    response.should redirect_to(om_account_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe OmAccountsController, "handling PUT /om_accounts/1" do

  before do
    @om_account = mock_model(OmAccount, :to_param => "1")
    OmAccount.stub!(:find).and_return(@om_account)
  end
  
  def put_with_successful_update
    @om_account.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @om_account.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the om_account requested" do
    OmAccount.should_receive(:find).with("1").and_return(@om_account)
    put_with_successful_update
  end

  it "should update the found om_account" do
    put_with_successful_update
    assigns(:om_account).should equal(@om_account)
  end

  it "should assign the found om_account for the view" do
    put_with_successful_update
    assigns(:om_account).should equal(@om_account)
  end

  it "should redirect to the om_account on successful update" do
    put_with_successful_update
    response.should redirect_to(om_account_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe OmAccountsController, "handling DELETE /om_accounts/1" do

  before do
    @om_account = mock_model(OmAccount, :destroy => true)
    OmAccount.stub!(:find).and_return(@om_account)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the om_account requested" do
    OmAccount.should_receive(:find).with("1").and_return(@om_account)
    do_delete
  end
  
  it "should call destroy on the found om_account" do
    @om_account.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the om_accounts list" do
    do_delete
    response.should redirect_to(om_accounts_url)
  end
end
