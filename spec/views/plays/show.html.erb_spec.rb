require File.dirname(__FILE__) + '/../../spec_helper'

describe "/plays/show.html.erb" do
  include PlaysHelper
  
  before(:each) do
    @play = mock_model(Play)
    @play.stub!(:description).and_return("MyText")
    @play.stub!(:notes).and_return("MyText")
    @play.stub!(:account_omrl).and_return("MyString")
    @play.stub!(:currency_omrl).and_return("MyString")
    @play.stub!(:player_id).and_return("1")
    @play.stub!(:creator_id).and_return("1")
    @play.stub!(:project_id).and_return("1")
    @play.stub!(:start_date).and_return(Time.now)
    @play.stub!(:end_date).and_return(Time.now)
    @play.stub!(:status).and_return("MyString")
    @play.stub!(:value).and_return("1")

    assigns[:play] = @play
  end

  it "should render attributes in <p>" do
    render "/plays/show.html.erb"
    response.should have_text(/MyText/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/1/)
  end
end

