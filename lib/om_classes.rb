######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################
require "config/omsite"

class Event < ActiveResource::Base
  include Specification
  self.site = Configuration.get(:server) if ActiveRecord::Base.connection.tables.include?(:configurations)
  
  def Event.churn(event_type,specification)
    event_spec = {
      :event_type => event_type.to_s,
      :specification => specification.to_yaml
#      :specification => specification.to_xml(:root => 'specification')
    }
    event = new(event_spec)
    begin
      event.save
    rescue Exception => e
      err = case e.response.code
      when '406'
        "invalid credential or parameter"
      when '500'
        "internal error -- check the om server log for details"
      else
        e.to_s
      end
      event.errors.add_to_base("The om server reported error: #{err} (#{e.response.code})")
    end
    #TODO we need to do this because at this point enmeshing errors the errors aren't coming back
    # from the server in the usual way.  This needs to be fixed.
    if event.respond_to?(:error)
      event.errors.add_to_base(event.error)
    end
    event
  end
end

class OMResource < ActiveResource::Base
  self.site = Configuration.get(:server) if ActiveRecord::Base.connection.tables.include?(:configurations)
  include Specification
  def self.find_by_omrl(omrl,*args)
    omrl = CGI.escape(omrl).gsub(/\./,'%2E') if !omrl.nil?
    self.find(omrl,*args)
  end
end

class Entity < OMResource
end
class Context < OMResource
end
class Account < OMResource
end
class Currency < OMResource
  def summaries
    summaries = self.attributes['summary']
    case summaries
    when nil
      nil
    when Array
      s = {'account' => {},'currency' => {},'context' => {}}
      summaries.each do |summary|
        s[summary.attributes['type']][summary.attributes['omrl']] = summary.attributes
      end
      s
    else
      {summaries.attributes['omrl'] => summary.attributes}
    end
  end
end
class Flow < OMResource
end