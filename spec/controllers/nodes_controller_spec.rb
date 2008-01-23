require File.dirname(__FILE__) + '/../spec_helper'

describe NodesController do
  describe "handling GET /nodes" do

    before(:each) do
      @node = mock_model(Node)
      Node.stub!(:find).and_return([@node])
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
  
    it "should find all nodes" do
      Node.should_receive(:find).with(:all).and_return([@node])
      do_get
    end
  
    it "should assign the found nodes for the view" do
      do_get
      assigns[:nodes].should == [@node]
    end
  end

  describe "handling GET /nodes.xml" do

    before(:each) do
      @node = mock_model(Node, :to_xml => "XML")
      Node.stub!(:find).and_return(@node)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all nodes" do
      Node.should_receive(:find).with(:all).and_return([@node])
      do_get
    end
  
    it "should render the found nodes as xml" do
      @node.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /nodes/1" do

    before(:each) do
      @node = mock_model(Node)
      Node.stub!(:find).and_return(@node)
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
  
    it "should find the node requested" do
      Node.should_receive(:find).with("1").and_return(@node)
      do_get
    end
  
    it "should assign the found node for the view" do
      do_get
      assigns[:node].should equal(@node)
    end
  end

  describe "handling GET /nodes/1.xml" do

    before(:each) do
      @node = mock_model(Node, :to_xml => "XML")
      Node.stub!(:find).and_return(@node)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the node requested" do
      Node.should_receive(:find).with("1").and_return(@node)
      do_get
    end
  
    it "should render the found node as xml" do
      @node.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /nodes/new" do

    before(:each) do
      @node = mock_model(Node)
      Node.stub!(:new).and_return(@node)
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
  
    it "should create an new node" do
      Node.should_receive(:new).and_return(@node)
      do_get
    end
  
    it "should not save the new node" do
      @node.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new node for the view" do
      do_get
      assigns[:node].should equal(@node)
    end
  end

  describe "handling GET /nodes/1/edit" do

    before(:each) do
      @node = mock_model(Node)
      Node.stub!(:find).and_return(@node)
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
  
    it "should find the node requested" do
      Node.should_receive(:find).and_return(@node)
      do_get
    end
  
    it "should assign the found Node for the view" do
      do_get
      assigns[:node].should equal(@node)
    end
  end

  describe "handling POST /nodes" do

    before(:each) do
      @node = mock_model(Node, :to_param => "1")
      Node.stub!(:new).and_return(@node)
    end
    
    describe "with successful save" do
  
      def do_post
        @node.should_receive(:save).and_return(true)
        post :create, :node => {}
      end
  
      it "should create a new node" do
        Node.should_receive(:new).with({}).and_return(@node)
        do_post
      end

      it "should redirect to the new node" do
        do_post
        response.should redirect_to(node_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @node.should_receive(:save).and_return(false)
        post :create, :node => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /nodes/1" do

    before(:each) do
      @node = mock_model(Node, :to_param => "1")
      Node.stub!(:find).and_return(@node)
    end
    
    describe "with successful update" do

      def do_put
        @node.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the node requested" do
        Node.should_receive(:find).with("1").and_return(@node)
        do_put
      end

      it "should update the found node" do
        do_put
        assigns(:node).should equal(@node)
      end

      it "should assign the found node for the view" do
        do_put
        assigns(:node).should equal(@node)
      end

      it "should redirect to the node" do
        do_put
        response.should redirect_to(node_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @node.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /nodes/1" do

    before(:each) do
      @node = mock_model(Node, :destroy => true)
      Node.stub!(:find).and_return(@node)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the node requested" do
      Node.should_receive(:find).with("1").and_return(@node)
      do_delete
    end
  
    it "should call destroy on the found node" do
      @node.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the nodes list" do
      do_delete
      response.should redirect_to(nodes_url)
    end
  end
end