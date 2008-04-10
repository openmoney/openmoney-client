class Configuration < ActiveRecord::Base
  Types = %w(boolean options string text)
  def Configuration.get(config_name)
    c = Configuration.find_by_name(config_name.to_s)
    c.value if c
  end
  
  def after_save
    if self.name == 'server'
      Event.site = self.value
      Entity.site = self.value
      Context.site = self.value
      Account.site = self.value
      Currency.site = self.value
      Flow.site = self.value
      OMResource.site = self.value
    end
  end
end
