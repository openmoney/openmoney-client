require File.dirname(__FILE__) + '/../../spec_helper'

describe "/om_currencies/new.html.erb" do
  include OmCurrenciesHelper
  
  before do
    @om_currency = mock_model(OmCurrency)
    @om_currency.stub!(:new_record?).and_return(true)
    @om_currency.stub!(:user_id).and_return("1")
    @om_currency.stub!(:omrl).and_return("MyString")
    @om_currency.stub!(:credentials).and_return("MyText")
    assigns[:om_currency] = @om_currency
  end

  it "should render new form" do
    render "/om_currencies/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", om_currencies_path) do
      with_tag("input#om_currency_omrl[name=?]", "om_currency[omrl]")
      with_tag("textarea#om_currency_credentials[name=?]", "om_currency[credentials]")
    end
  end
end


