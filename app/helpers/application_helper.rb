######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

require "config/omsite"

class Event < ActiveResource::Base
  include Specification
  self.site = SITE_URL
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

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include L8n
end
