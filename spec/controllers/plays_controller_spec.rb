require File.dirname(__FILE__) + '/../spec_helper'

describe PlaysController do
  describe "handling GET /plays" do

    before(:each) do
      @play = mock_model(Play)
      Play.stub!(:find).and_return([@play])
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
  
    it "should find all plays" do
      Play.should_receive(:find).with(:all).and_return([@play])
      do_get
    end
  
    it "should assign the found plays for the view" do
      do_get
      assigns[:plays].should == [@play]
    end
  end

  describe "handling GET /plays.xml" do

    before(:each) do
      @play = mock_model(Play, :to_xml => "XML")
      Play.stub!(:find).and_return(@play)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all plays" do
      Play.should_receive(:find).with(:all).and_return([@play])
      do_get
    end
  
    it "should render the found plays as xml" do
      @play.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /plays/1" do

    before(:each) do
      @play = mock_model(Play)
      Play.stub!(:find).and_return(@play)
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
  
    it "should find the play requested" do
      Play.should_receive(:find).with("1").and_return(@play)
      do_get
    end
  
    it "should assign the found play for the view" do
      do_get
      assigns[:play].should equal(@play)
    end
  end

  describe "handling GET /plays/1.xml" do

    before(:each) do
      @play = mock_model(Play, :to_xml => "XML")
      Play.stub!(:find).and_return(@play)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the play requested" do
      Play.should_receive(:find).with("1").and_return(@play)
      do_get
    end
  
    it "should render the found play as xml" do
      @play.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /plays/new" do

    before(:each) do
      @play = mock_model(Play)
      Play.stub!(:new).and_return(@play)
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
  
    it "should create an new play" do
      Play.should_receive(:new).and_return(@play)
      do_get
    end
  
    it "should not save the new play" do
      @play.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new play for the view" do
      do_get
      assigns[:play].should equal(@play)
    end
  end

  describe "handling GET /plays/1/edit" do

    before(:each) do
      @play = mock_model(Play)
      Play.stub!(:find).and_return(@play)
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
  
    it "should find the play requested" do
      Play.should_receive(:find).and_return(@play)
      do_get
    end
  
    it "should assign the found Play for the view" do
      do_get
      assigns[:play].should equal(@play)
    end
  end

  describe "handling POST /plays" do

    before(:each) do
      @play = mock_model(Play, :to_param => "1")
      Play.stub!(:new).and_return(@play)
    end
    
    describe "with successful save" do
  
      def do_post
        @play.should_receive(:save).and_return(true)
        post :create, :play => {}
      end
  
      it "should create a new play" do
        Play.should_receive(:new).with({}).and_return(@play)
        do_post
      end

      it "should redirect to the new play" do
        do_post
        response.should redirect_to(play_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @play.should_receive(:save).and_return(false)
        post :create, :play => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /plays/1" do

    before(:each) do
      @play = mock_model(Play, :to_param => "1")
      Play.stub!(:find).and_return(@play)
    end
    
    describe "with successful update" do

      def do_put
        @play.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the play requested" do
        Play.should_receive(:find).with("1").and_return(@play)
        do_put
      end

      it "should update the found play" do
        do_put
        assigns(:play).should equal(@play)
      end

      it "should assign the found play for the view" do
        do_put
        assigns(:play).should equal(@play)
      end

      it "should redirect to the play" do
        do_put
        response.should redirect_to(play_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @play.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /plays/1" do

    before(:each) do
      @play = mock_model(Play, :destroy => true)
      Play.stub!(:find).and_return(@play)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the play requested" do
      Play.should_receive(:find).with("1").and_return(@play)
      do_delete
    end
  
    it "should call destroy on the found play" do
      @play.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the plays list" do
      do_delete
      response.should redirect_to(plays_url)
    end
  end
end