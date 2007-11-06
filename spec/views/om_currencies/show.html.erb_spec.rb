require File.dirname(__FILE__) + '/../../spec_helper'

describe "/om_currencies/show.html.erb" do
  include OmCurrenciesHelper
  
  before do
    @om_currency = mock_model(OmCurrency)
    @om_currency.stub!(:user_id).and_return("1")
    @om_currency.stub!(:omrl).and_return("MyString")
    @om_currency.stub!(:credentials).and_return("MyText")

    assigns[:om_currency] = @om_currency
  end

  it "should render attributes in <p>" do
    render "/om_currencies/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end

