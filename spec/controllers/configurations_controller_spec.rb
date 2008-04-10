require File.dirname(__FILE__) + '/../spec_helper'

describe ConfigurationsController do
  describe "handling GET /configurations" do

    before(:each) do
      @configuration = mock_model(Configuration)
      Configuration.stub!(:find).and_return([@configuration])
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
  
    it "should find all configurations" do
      Configuration.should_receive(:find).with(:all).and_return([@configuration])
      do_get
    end
  
    it "should assign the found configurations for the view" do
      do_get
      assigns[:configurations].should == [@configuration]
    end
  end

  describe "handling GET /configurations.xml" do

    before(:each) do
      @configuration = mock_model(Configuration, :to_xml => "XML")
      Configuration.stub!(:find).and_return(@configuration)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all configurations" do
      Configuration.should_receive(:find).with(:all).and_return([@configuration])
      do_get
    end
  
    it "should render the found configurations as xml" do
      @configuration.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /configurations/1" do

    before(:each) do
      @configuration = mock_model(Configuration)
      Configuration.stub!(:find).and_return(@configuration)
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
  
    it "should find the configuration requested" do
      Configuration.should_receive(:find).with("1").and_return(@configuration)
      do_get
    end
  
    it "should assign the found configuration for the view" do
      do_get
      assigns[:configuration].should equal(@configuration)
    end
  end

  describe "handling GET /configurations/1.xml" do

    before(:each) do
      @configuration = mock_model(Configuration, :to_xml => "XML")
      Configuration.stub!(:find).and_return(@configuration)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the configuration requested" do
      Configuration.should_receive(:find).with("1").and_return(@configuration)
      do_get
    end
  
    it "should render the found configuration as xml" do
      @configuration.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /configurations/new" do

    before(:each) do
      @configuration = mock_model(Configuration)
      Configuration.stub!(:new).and_return(@configuration)
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
  
    it "should create an new configuration" do
      Configuration.should_receive(:new).and_return(@configuration)
      do_get
    end
  
    it "should not save the new configuration" do
      @configuration.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new configuration for the view" do
      do_get
      assigns[:configuration].should equal(@configuration)
    end
  end

  describe "handling GET /configurations/1/edit" do

    before(:each) do
      @configuration = mock_model(Configuration)
      Configuration.stub!(:find).and_return(@configuration)
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
  
    it "should find the configuration requested" do
      Configuration.should_receive(:find).and_return(@configuration)
      do_get
    end
  
    it "should assign the found Configuration for the view" do
      do_get
      assigns[:configuration].should equal(@configuration)
    end
  end

  describe "handling POST /configurations" do

    before(:each) do
      @configuration = mock_model(Configuration, :to_param => "1")
      Configuration.stub!(:new).and_return(@configuration)
    end
    
    describe "with successful save" do
  
      def do_post
        @configuration.should_receive(:save).and_return(true)
        post :create, :configuration => {}
      end
  
      it "should create a new configuration" do
        Configuration.should_receive(:new).with({}).and_return(@configuration)
        do_post
      end

      it "should redirect to the new configuration" do
        do_post
        response.should redirect_to(configuration_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @configuration.should_receive(:save).and_return(false)
        post :create, :configuration => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /configurations/1" do

    before(:each) do
      @configuration = mock_model(Configuration, :to_param => "1")
      Configuration.stub!(:find).and_return(@configuration)
    end
    
    describe "with successful update" do

      def do_put
        @configuration.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the configuration requested" do
        Configuration.should_receive(:find).with("1").and_return(@configuration)
        do_put
      end

      it "should update the found configuration" do
        do_put
        assigns(:configuration).should equal(@configuration)
      end

      it "should assign the found configuration for the view" do
        do_put
        assigns(:configuration).should equal(@configuration)
      end

      it "should redirect to the configuration" do
        do_put
        response.should redirect_to(configuration_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @configuration.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /configurations/1" do

    before(:each) do
      @configuration = mock_model(Configuration, :destroy => true)
      Configuration.stub!(:find).and_return(@configuration)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the configuration requested" do
      Configuration.should_receive(:find).with("1").and_return(@configuration)
      do_delete
    end
  
    it "should call destroy on the found configuration" do
      @configuration.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the configurations list" do
      do_delete
      response.should redirect_to(configurations_url)
    end
  end
end