require File.dirname(__FILE__) + '/../../spec_helper'

describe "/om_accounts/show.html.erb" do
  include OmAccountsHelper
  
  before do
    @om_account = mock_model(OmAccount)
    @om_account.stub!(:user_id).and_return("1")
    @om_account.stub!(:omrl).and_return("MyString")
    @om_account.stub!(:password).and_return("MyString")
    @om_account.stub!(:currencies_cache).and_return("MyText")

    assigns[:om_account] = @om_account
  end

  it "should render attributes in <p>" do
    render "/om_accounts/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end

