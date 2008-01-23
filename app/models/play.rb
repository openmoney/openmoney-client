class Play < ActiveRecord::Base
  belongs_to :player, :class_name => "User", :foreign_key => "player_id"
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :project, :class_name => "Node", :foreign_key => "project_id"
  Statuses = %w(pending submitted approved retired)

  def project_name
    self.project.nil? ? '--' : self.project.name
  end
  
  def player_name
    self.player.nil? ? '--' : self.player.full_name
  end
    
  def approve
    project_account = self.project.get_account
    return ["project account not found"] if project_account.nil?
    event = Event.churn(:AcknowledgeFlow,
      "credentials" => {project_account.omrl => YAML.load(project_account.credentials)},
      "flow_specification" => {
        :description => "play id #{self.id}: #{self.description}",
        :amount => self.value
        },
      "flow_uid" => Time.now,
      "declaring_account" => project_account.omrl,
      "accepting_account" => self.account_omrl,
      "currency" => self.currency_omrl
    )
    if event.errors.empty?
      self.status = 'approved'
      self.save
      []
    else
      event.errors.full_messages
    end
  end
end
