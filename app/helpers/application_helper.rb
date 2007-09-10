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
  
  # stub for localizing
  def l(text)
    text = text.to_s
    map = {'es' => {
      'Yes' => 'Si',
      'No' => 'No',
      'Date' => 'Fecha',
      'Declarer' => 'Declarador',
      'Accepter' => 'Acceptador',
      'Currency' => 'Moneda'
      }}
    k = map[current_user.pref_language]
    
    if k
      k[text] || text
    else  
      text
    end
  end
  
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
        render_field($1,field_spec,language)
      end
    }
  end

  def get_field_spec(field_name,field_spec)
    fspec = field_spec[field_name]
    fspec = field_name if fspec.nil?
    case
    when fspec.is_a?(String)
      fspec = {'type' => fspec}
    when fspec.is_a?(Array)
      fspec = {'values_enum' => fspec}
    end
    fspec['description'] = field_name.gsub(/_/,' ').capitalize if !fspec['description']
    fspec
  end
  
  def render_field(field_name,field_spec,language = 'en')
    fspec = get_field_spec(field_name,field_spec)
    
    html_field_name = "flow_spec[#{field_name}]"
    
    field_description = fspec['description']
    field_description = field_description[language] if field_description.is_a?(Hash)

    field_type = fspec['type']
    case 
    when fspec['values_enum']
      enum = fspec['values_enum']
      enum = enum[language] if enum.is_a?(Hash)
      select_tag(html_field_name,options_for_select(enum,@params[field_name]))
    when field_type == "boolean"
      select_tag(html_field_name,options_for_select([[l('Yes'), "true"], [l('No'), "false"]],@params[field_name]))
    when field_type == "submit"
      submit_tag(field_description)
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
  
  def history(account, currency_omrl,sort_order = nil,language = "en",count = 20,page = 0)
    account_omrl = account.omrl
    flows = Flow.find(:all, :params => { :with => account_omrl, :in_currency => currency_omrl })
    fields = account.currency_specification(currency_omrl)['fields']
    fields ||= DefaultCurrencyFields
    f = {}
    
    fields.keys.each do |name|
      fspec = get_field_spec(name,fields)
      type = fspec['type']
      if type != 'submit'  && type != 'unit'
        field_description = fspec['description']
        field_description = field_description[language] if field_description.is_a?(Hash)
        f[name] = field_description
      end
    end
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
