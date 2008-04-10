require File.dirname(__FILE__) + '/../spec_helper'

describe ConfigurationsController do
  describe "route generation" do

    it "should map { :controller => 'configurations', :action => 'index' } to /configurations" do
      route_for(:controller => "configurations", :action => "index").should == "/configurations"
    end
  
    it "should map { :controller => 'configurations', :action => 'new' } to /configurations/new" do
      route_for(:controller => "configurations", :action => "new").should == "/configurations/new"
    end
  
    it "should map { :controller => 'configurations', :action => 'show', :id => 1 } to /configurations/1" do
      route_for(:controller => "configurations", :action => "show", :id => 1).should == "/configurations/1"
    end
  
    it "should map { :controller => 'configurations', :action => 'edit', :id => 1 } to /configurations/1/edit" do
      route_for(:controller => "configurations", :action => "edit", :id => 1).should == "/configurations/1/edit"
    end
  
    it "should map { :controller => 'configurations', :action => 'update', :id => 1} to /configurations/1" do
      route_for(:controller => "configurations", :action => "update", :id => 1).should == "/configurations/1"
    end
  
    it "should map { :controller => 'configurations', :action => 'destroy', :id => 1} to /configurations/1" do
      route_for(:controller => "configurations", :action => "destroy", :id => 1).should == "/configurations/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'configurations', action => 'index' } from GET /configurations" do
      params_from(:get, "/configurations").should == {:controller => "configurations", :action => "index"}
    end
  
    it "should generate params { :controller => 'configurations', action => 'new' } from GET /configurations/new" do
      params_from(:get, "/configurations/new").should == {:controller => "configurations", :action => "new"}
    end
  
    it "should generate params { :controller => 'configurations', action => 'create' } from POST /configurations" do
      params_from(:post, "/configurations").should == {:controller => "configurations", :action => "create"}
    end
  
    it "should generate params { :controller => 'configurations', action => 'show', id => '1' } from GET /configurations/1" do
      params_from(:get, "/configurations/1").should == {:controller => "configurations", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'configurations', action => 'edit', id => '1' } from GET /configurations/1;edit" do
      params_from(:get, "/configurations/1/edit").should == {:controller => "configurations", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'configurations', action => 'update', id => '1' } from PUT /configurations/1" do
      params_from(:put, "/configurations/1").should == {:controller => "configurations", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'configurations', action => 'destroy', id => '1' } from DELETE /configurations/1" do
      params_from(:delete, "/configurations/1").should == {:controller => "configurations", :action => "destroy", :id => "1"}
    end
  end
end