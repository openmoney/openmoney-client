require File.dirname(__FILE__) + '/../spec_helper'

describe OmAccount do
  before(:each) do
    @om_account = OmAccount.new
  end

  it "should be valid" do
    @om_account.should be_valid
  end
end
