require File.dirname(__FILE__) + '/../../spec_helper'

describe "/nodes/index.html.erb" do
  include NodesHelper
  
  before(:each) do
    node_98 = mock_model(Node)
    node_98.should_receive(:name).and_return("MyString")
    node_98.should_receive(:body).and_return("MyText")
    node_98.should_receive(:account_omrl).and_return("MyString")
    node_99 = mock_model(Node)
    node_99.should_receive(:name).and_return("MyString")
    node_99.should_receive(:body).and_return("MyText")
    node_99.should_receive(:account_omrl).and_return("MyString")

    assigns[:nodes] = [node_98, node_99]
  end

  it "should render list of nodes" do
    render "/nodes/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
  end
end

