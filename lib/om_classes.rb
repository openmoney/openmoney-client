######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################
require "config/omsite"

class Event < ActiveResource::Base
  include Specification
  self.site = SITE_URL
  
  def Event.churn(event_type,specification)
    event_spec = {
      :event_type => event_type.to_s,
      :specification => specification.to_yaml
    }
    event = new(event_spec)
    event.save
    #TODO we need to do this because at this point enmeshing errors the errors aren't coming back
    # from the server in the usual way.  This needs to be fixed.
    if event.respond_to?(:error)
      event.errors.add_to_base(event.error)
    end
    event
  end
end

class Entity < ActiveResource::Base
  include Specification
  self.site = SITE_URL
end
class Account < ActiveResource::Base
  include Specification
  self.site = SITE_URL
end
class Currency < ActiveResource::Base
  include Specification
  self.site = SITE_URL
end
class Flow < ActiveResource::Base
  include Specification
  self.site = SITE_URL
end