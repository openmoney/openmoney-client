require File.dirname(__FILE__) + '/../spec_helper'

describe OmCurrency do
  before(:each) do
    @om_currency = OmCurrency.new
  end

  it "should be valid" do
    @om_currency.should be_valid
  end
end
