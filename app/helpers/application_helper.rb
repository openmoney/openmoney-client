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

  DefaultCurrencyFields = {"amount" => "float", "description" => "text"}
  
  def currency_select(html_field_name,selected,account = nil)
    c = Currency.find(:all).collect{|e| e.omrl.chop}
    select_tag(html_field_name,options_for_select(c,selected))
  end

  def contexts_select(html_field_name,selected)
    c = Entity.find(:all, :conditions => "entity_type = 'context' ").collect{|e| e.omrl.chop}
    select_tag(html_field_name,options_for_select(c,selected))
  end
  
  def unit_of_measure_select(html_field_name,selected = nil)
    select_tag(html_field_name, <<-EOHTML
		<option value="USD">US Dollar ($)</option>
		<option value="EUR">Euro (&euro;)</option>
		<option value="CAD">Canadian Dollar ($)</option>
		<option value="AUD">Australian Dollar ($)</option>
		<option value="NZD">New Zeland Dollar ($)</option>
		<option value="S">Sterling Pound (&pound;)</option>
		<option value="MXP">Mexican Peso (p)</option>
		<option value="YEN">Yen (&yen;)</option>
		<option value="CHY">Yuan</option>
		<option value="T-h">Time:hours (h)</option>
		<option value="T-m">Time:minutes (m)</option>
		<option value="kwh">Kilowatt Hours (kwh)</option>
		<option value="other">other--see description (&curren;)</option>
    EOHTML
    )
  end
  
  def input_form(currency_spec,declaring_account=nil,language = "en")
    base_field_spec = {"submit" => "submit","USD" => 'unit'}
    if currency_spec["fields"]
      field_spec = currency_spec["fields"]
    else
      field_spec = DefaultCurrencyFields
    end
    field_spec = base_field_spec.merge(field_spec)
#    return spec.inspect
    if currency_spec["input_form"]
      form = currency_spec["input_form"][language]
      form ||= currency_spec["input_form"]['en']
    else
      form = ":declaring_account acknowledges :accepting_account for :description in the amount of :USD:amount :submit"
    end
    form.gsub(/:([a-zA-Z0-9_-]+)/) {|m| 
      if $1 == 'declaring_account' && declaring_account
        declaring_account
      else
        render_field($1,field_spec)
      end
    }
  end

  def render_field(field_name,field_spec)

    field_type = field_spec[field_name]
    html_field_name = "flow_spec[#{field_name}]"
    case 
    when field_type.is_a?(Array)
      select_tag(html_field_name,options_for_select(field_type,@params[field_name]))
    when field_type == "boolean"
      select_tag(html_field_name,options_for_select([["Yes", "Y"], ["No", "N"]],@params[field_name]))
    when field_type == "submit"
      submit_tag(field_name.gsub(/_/,' '))
    when field_type == "text"
      text_field_tag(html_field_name,@params[field_name])
    when field_type == "float"
      text_field_tag(html_field_name,@params[field_name])
    when field_type == "unit"
      {
        'USD'=>'$',
        'EUR'=>'&euro;',
        'CAD'=>'$',
        'AUD'=>'$',
        'NZD'=>'$',
        'S'=>'&pound;',
        'MXP'=>'p',
        'YEN'=>'&yen;',
        "CHY"=>'Yuan',
        'T-h'=>'h',
        'T-m'=>'m',
        'kwh'=>'kwh',
        'other'=>'&curren;'
      }[field_name]
    else
      text_field_tag(field_name,@params[field_name])
    end
  end
  
  def history(account, currency_omrl,sort_order = nil,count = 20,page = 0,language = "en")
    account_omrl = account.omrl
    flows = Flow.find(:all, :params => { :with => account_omrl, :in_currency => currency_omrl })
    fields = account.currency_specification(currency_omrl)['fields']
    fields ||= DefaultCurrencyFields
    f = {}
    fields.each{|name,type| f[name] = type if type != 'submit'  && type != 'unit'}
    if sort_order =~ /^-(.*)/
      reverse = true
      sort_order = $1
    end
    if sort_order == nil or sort_order == ''
      flows = flows.sort_by {|a| a.created_at}.reverse
    else
      flows = flows.sort_by {|a| a.specification_attribute(sort_order)}
    end
    flows = flows.reverse if reverse
    [flows,f]
  end
  
end
