require File.dirname(__FILE__) + '/../spec_helper'

describe Configuration do
  before(:each) do
    @configuration = Configuration.new
  end

  it "should be valid" do
    @configuration.should be_valid
  end
end
