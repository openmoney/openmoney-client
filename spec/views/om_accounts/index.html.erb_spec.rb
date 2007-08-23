require File.dirname(__FILE__) + '/../../spec_helper'

describe "/om_accounts/index.html.erb" do
  include OmAccountsHelper
  
  before do
    om_account_98 = mock_model(OmAccount)
    om_account_98.should_receive(:user_id).and_return("1")
    om_account_98.should_receive(:omrl).and_return("MyString")
    om_account_98.should_receive(:password).and_return("MyString")
    om_account_98.should_receive(:currencies_cache).and_return("MyText")
    om_account_99 = mock_model(OmAccount)
    om_account_99.should_receive(:user_id).and_return("1")
    om_account_99.should_receive(:omrl).and_return("MyString")
    om_account_99.should_receive(:password).and_return("MyString")
    om_account_99.should_receive(:currencies_cache).and_return("MyText")

    assigns[:om_accounts] = [om_account_98, om_account_99]
  end

  it "should render list of om_accounts" do
    render "/om_accounts/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
  end
end

