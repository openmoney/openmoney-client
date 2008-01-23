require File.dirname(__FILE__) + '/../spec_helper'

describe PlaysController do
  describe "route generation" do

    it "should map { :controller => 'plays', :action => 'index' } to /plays" do
      route_for(:controller => "plays", :action => "index").should == "/plays"
    end
  
    it "should map { :controller => 'plays', :action => 'new' } to /plays/new" do
      route_for(:controller => "plays", :action => "new").should == "/plays/new"
    end
  
    it "should map { :controller => 'plays', :action => 'show', :id => 1 } to /plays/1" do
      route_for(:controller => "plays", :action => "show", :id => 1).should == "/plays/1"
    end
  
    it "should map { :controller => 'plays', :action => 'edit', :id => 1 } to /plays/1/edit" do
      route_for(:controller => "plays", :action => "edit", :id => 1).should == "/plays/1/edit"
    end
  
    it "should map { :controller => 'plays', :action => 'update', :id => 1} to /plays/1" do
      route_for(:controller => "plays", :action => "update", :id => 1).should == "/plays/1"
    end
  
    it "should map { :controller => 'plays', :action => 'destroy', :id => 1} to /plays/1" do
      route_for(:controller => "plays", :action => "destroy", :id => 1).should == "/plays/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'plays', action => 'index' } from GET /plays" do
      params_from(:get, "/plays").should == {:controller => "plays", :action => "index"}
    end
  
    it "should generate params { :controller => 'plays', action => 'new' } from GET /plays/new" do
      params_from(:get, "/plays/new").should == {:controller => "plays", :action => "new"}
    end
  
    it "should generate params { :controller => 'plays', action => 'create' } from POST /plays" do
      params_from(:post, "/plays").should == {:controller => "plays", :action => "create"}
    end
  
    it "should generate params { :controller => 'plays', action => 'show', id => '1' } from GET /plays/1" do
      params_from(:get, "/plays/1").should == {:controller => "plays", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'plays', action => 'edit', id => '1' } from GET /plays/1;edit" do
      params_from(:get, "/plays/1/edit").should == {:controller => "plays", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'plays', action => 'update', id => '1' } from PUT /plays/1" do
      params_from(:put, "/plays/1").should == {:controller => "plays", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'plays', action => 'destroy', id => '1' } from DELETE /plays/1" do
      params_from(:delete, "/plays/1").should == {:controller => "plays", :action => "destroy", :id => "1"}
    end
  end
end