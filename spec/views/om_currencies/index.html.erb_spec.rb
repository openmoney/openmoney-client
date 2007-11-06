require File.dirname(__FILE__) + '/../../spec_helper'

describe "/om_currencies/index.html.erb" do
  include OmCurrenciesHelper
  
  before do
    om_currency_98 = mock_model(OmCurrency)
    om_currency_98.should_receive(:user_id).and_return("1")
    om_currency_98.should_receive(:omrl).and_return("MyString")
    om_currency_98.should_receive(:credentials).and_return("MyText")
    om_currency_99 = mock_model(OmCurrency)
    om_currency_99.should_receive(:user_id).and_return("1")
    om_currency_99.should_receive(:omrl).and_return("MyString")
    om_currency_99.should_receive(:credentials).and_return("MyText")

    assigns[:om_currencies] = [om_currency_98, om_currency_99]
  end

  it "should render list of om_currencies" do
    render "/om_currencies/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
  end
end

