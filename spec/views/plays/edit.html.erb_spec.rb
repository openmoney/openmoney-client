require File.dirname(__FILE__) + '/../../spec_helper'

describe "/plays/edit.html.erb" do
  include PlaysHelper
  
  before do
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

  it "should render edit form" do
    render "/plays/edit.html.erb"
    
    response.should have_tag("form[action=#{play_path(@play)}][method=post]") do
      with_tag('textarea#play_description[name=?]', "play[description]")
      with_tag('textarea#play_notes[name=?]', "play[notes]")
      with_tag('input#play_account_omrl[name=?]', "play[account_omrl]")
      with_tag('input#play_currency_omrl[name=?]', "play[currency_omrl]")
      with_tag('input#play_status[name=?]', "play[status]")
      with_tag('input#play_value[name=?]', "play[value]")
    end
  end
end


