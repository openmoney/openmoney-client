require File.dirname(__FILE__) + '/../../spec_helper'

describe "/nodes/edit.html.erb" do
  include NodesHelper
  
  before do
    @node = mock_model(Node)
    @node.stub!(:name).and_return("MyString")
    @node.stub!(:body).and_return("MyText")
    @node.stub!(:account_omrl).and_return("MyString")
    assigns[:node] = @node
  end

  it "should render edit form" do
    render "/nodes/edit.html.erb"
    
    response.should have_tag("form[action=#{node_path(@node)}][method=post]") do
      with_tag('input#node_name[name=?]', "node[name]")
      with_tag('textarea#node_body[name=?]', "node[body]")
      with_tag('input#node_account_omrl[name=?]', "node[account_omrl]")
    end
  end
end


