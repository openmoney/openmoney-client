require File.dirname(__FILE__) + '/../../spec_helper'

describe "/configurations/new.html.erb" do
  include ConfigurationsHelper
  
  before(:each) do
    @configuration = mock_model(Configuration)
    @configuration.stub!(:new_record?).and_return(true)
    @configuration.stub!(:name).and_return("MyString")
    @configuration.stub!(:configuration_type).and_return("MyString")
    @configuration.stub!(:value).and_return("MyText")
    assigns[:configuration] = @configuration
  end

  it "should render new form" do
    render "/configurations/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", configurations_path) do
      with_tag("input#configuration_name[name=?]", "configuration[name]")
      with_tag("input#configuration_configuration_type[name=?]", "configuration[configuration_type]")
      with_tag("textarea#configuration_value[name=?]", "configuration[value]")
    end
  end
end


