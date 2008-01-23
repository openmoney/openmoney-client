require File.dirname(__FILE__) + '/../../spec_helper'

describe "/nodes/show.html.erb" do
  include NodesHelper
  
  before(:each) do
    @node = mock_model(Node)
    @node.stub!(:name).and_return("MyString")
    @node.stub!(:body).and_return("MyText")
    @node.stub!(:account_omrl).and_return("MyString")

    assigns[:node] = @node
  end

  it "should render attributes in <p>" do
    render "/nodes/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
  end
end

