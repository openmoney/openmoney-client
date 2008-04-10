require File.dirname(__FILE__) + '/../../spec_helper'

describe "/configurations/index.html.erb" do
  include ConfigurationsHelper
  
  before(:each) do
    configuration_98 = mock_model(Configuration)
    configuration_98.should_receive(:name).and_return("MyString")
    configuration_98.should_receive(:configuration_type).and_return("MyString")
    configuration_98.should_receive(:value).and_return("MyText")
    configuration_99 = mock_model(Configuration)
    configuration_99.should_receive(:name).and_return("MyString")
    configuration_99.should_receive(:configuration_type).and_return("MyString")
    configuration_99.should_receive(:value).and_return("MyText")

    assigns[:configurations] = [configuration_98, configuration_99]
  end

  it "should render list of configurations" do
    render "/configurations/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
  end
end

