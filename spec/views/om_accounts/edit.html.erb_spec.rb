require File.dirname(__FILE__) + '/../../spec_helper'

describe "/om_accounts/edit.html.erb" do
  include OmAccountsHelper
  
  before do
    @om_account = mock_model(OmAccount)
    @om_account.stub!(:user_id).and_return("1")
    @om_account.stub!(:omrl).and_return("MyString")
    @om_account.stub!(:password).and_return("MyString")
    @om_account.stub!(:currencies_cache).and_return("MyText")
    assigns[:om_account] = @om_account
  end

  it "should render edit form" do
    render "/om_accounts/edit.html.erb"
    
    response.should have_tag("form[action=#{om_account_path(@om_account)}][method=post]") do
      with_tag('input#om_account_omrl[name=?]', "om_account[omrl]")
      with_tag('input#om_account_password[name=?]', "om_account[password]")
      with_tag('textarea#om_account_currencies_cache[name=?]', "om_account[currencies_cache]")
    end
  end
end


