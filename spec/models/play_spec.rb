require File.dirname(__FILE__) + '/../spec_helper'

describe Play do
  before(:each) do
    @play = Play.new
  end

  it "should be valid" do
    @play.should be_valid
  end
end
