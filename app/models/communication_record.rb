class CommunicationRecord < ActiveRecord::Base
  POSSIBLE_EMOTIONS = [:angry, :sad, :blank, :happy, :superhappy]
  POSSIBLE_METHODS = [:phone, :email, :mail, :chat, :desk]

  # Associations
  belongs_to :organisation_client
  belongs_to :user
  belongs_to :reservation
  belongs_to :contact, class_name: 'OrganisationClientContact'

  # Attribute modifiers
  symbolize :emotion, :method

  # Validations
  validates :organisation_client, presence: true
  validates :user, presence: true
  validates :reservation_id, inclusion: { in: -> cr { cr.organisation_client.reservation_ids } }, if: -> { organisation_client.present? }
  validates :summary, presence: true
  validates :emotion, length: { maximum: 255 }, inclusion: { in: POSSIBLE_EMOTIONS }, allow_nil: true
  validates :method, length: { maximum: 255 }, inclusion: { in: POSSIBLE_METHODS }, allow_nil: true

  # Callbacks
  before_validation :set_current_user

  # Scopes
  default_scope { order(created_at: :desc) }

  ##
  # Instance methods
  ##

  def instance_name
    self.summary
  end

  def set_current_user
    self.user = User.current
  end
end
