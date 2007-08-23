require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.html.erb" do
  include UsersHelper
  
  before do
    @user = mock_model(User)
    @user.stub!(:first_name).and_return("MyString")
    @user.stub!(:last_name).and_return("MyString")
    @user.stub!(:email).and_return("MyString")
    @user.stub!(:last_login).and_return(Time.now)
    @user.stub!(:username).and_return("MyString")

    assigns[:user] = @user
  end

  it "should render attributes in <p>" do
    render "/users/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end

