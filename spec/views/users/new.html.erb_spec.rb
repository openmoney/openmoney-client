require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/new.html.erb" do
  include UsersHelper
  
  before do
    @user = mock_model(User)
    @user.stub!(:new_record?).and_return(true)
    @user.stub!(:first_name).and_return("MyString")
    @user.stub!(:last_name).and_return("MyString")
    @user.stub!(:email).and_return("MyString")
    @user.stub!(:last_login).and_return(Time.now)
    @user.stub!(:username).and_return("MyString")
    assigns[:user] = @user
  end

  it "should render new form" do
    render "/users/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_first_name[name=?]", "user[first_name]")
      with_tag("input#user_last_name[name=?]", "user[last_name]")
      with_tag("input#user_email[name=?]", "user[email]")
      with_tag("input#user_username[name=?]", "user[username]")
    end
  end
end


