class Configuration < ActiveRecord::Base
  Types = %w(options string text)
  def Configuration.get(config_name)
    c = Configuration.find_by_name(config_name.to_s)
    c.value if c
  end
  
  def after_save
    if self.name == 'server'
      OMUtils.set_server(self.value)
    end
  end
end
