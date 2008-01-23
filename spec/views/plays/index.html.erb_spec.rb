require File.dirname(__FILE__) + '/../../spec_helper'

describe "/plays/index.html.erb" do
  include PlaysHelper
  
  before(:each) do
    play_98 = mock_model(Play)
    play_98.should_receive(:description).and_return("MyText")
    play_98.should_receive(:notes).and_return("MyText")
    play_98.should_receive(:account_omrl).and_return("MyString")
    play_98.should_receive(:currency_omrl).and_return("MyString")
    play_98.should_receive(:player_id).and_return("1")
    play_98.should_receive(:creator_id).and_return("1")
    play_98.should_receive(:project_id).and_return("1")
    play_98.should_receive(:start_date).and_return(Time.now)
    play_98.should_receive(:end_date).and_return(Time.now)
    play_98.should_receive(:status).and_return("MyString")
    play_98.should_receive(:value).and_return("1")
    play_99 = mock_model(Play)
    play_99.should_receive(:description).and_return("MyText")
    play_99.should_receive(:notes).and_return("MyText")
    play_99.should_receive(:account_omrl).and_return("MyString")
    play_99.should_receive(:currency_omrl).and_return("MyString")
    play_99.should_receive(:player_id).and_return("1")
    play_99.should_receive(:creator_id).and_return("1")
    play_99.should_receive(:project_id).and_return("1")
    play_99.should_receive(:start_date).and_return(Time.now)
    play_99.should_receive(:end_date).and_return(Time.now)
    play_99.should_receive(:status).and_return("MyString")
    play_99.should_receive(:value).and_return("1")

    assigns[:plays] = [play_98, play_99]
  end

  it "should render list of plays" do
    render "/plays/index.html.erb"
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

