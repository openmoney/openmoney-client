require File.dirname(__FILE__) + '/../../spec_helper'

describe "/configurations/edit.html.erb" do
  include ConfigurationsHelper
  
  before do
    @configuration = mock_model(Configuration)
    @configuration.stub!(:name).and_return("MyString")
    @configuration.stub!(:configuration_type).and_return("MyString")
    @configuration.stub!(:value).and_return("MyText")
    assigns[:configuration] = @configuration
  end

  it "should render edit form" do
    render "/configurations/edit.html.erb"
    
    response.should have_tag("form[action=#{configuration_path(@configuration)}][method=post]") do
      with_tag('input#configuration_name[name=?]', "configuration[name]")
      with_tag('input#configuration_configuration_type[name=?]', "configuration[configuration_type]")
      with_tag('textarea#configuration_value[name=?]', "configuration[value]")
    end
  end
end


