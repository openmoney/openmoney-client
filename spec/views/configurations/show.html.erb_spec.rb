require File.dirname(__FILE__) + '/../../spec_helper'

describe "/configurations/show.html.erb" do
  include ConfigurationsHelper
  
  before(:each) do
    @configuration = mock_model(Configuration)
    @configuration.stub!(:name).and_return("MyString")
    @configuration.stub!(:configuration_type).and_return("MyString")
    @configuration.stub!(:value).and_return("MyText")

    assigns[:configuration] = @configuration
  end

  it "should render attributes in <p>" do
    render "/configurations/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end

