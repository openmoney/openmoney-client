require File.dirname(__FILE__) + '/../spec_helper'

describe NodesHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the NodeHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(NodesHelper)
  end
  
end
