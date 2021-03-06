class EntityType < ActiveRecord::Base
  include PgSearch
  include Sspable
  include Taggable

  # Associations
  belongs_to :organisation
  belongs_to :icon, class_name: 'EntityTypeIcon'

  has_many :entities, dependent: :destroy
  has_many :reservations, through: :entities
  has_many :properties, class_name: 'EntityTypeProperty', dependent: :destroy, inverse_of: :entity_type
  has_many :images, class_name: 'EntityImage', as: :imageable, dependent: :destroy, inverse_of: :imageable
  has_many :reservation_statuses, dependent: :destroy, inverse_of: :entity_type
  has_many :info_screen_entity_types, dependent: :destroy
  has_many :reservation_periods, dependent: :destroy, inverse_of: :entity_type

  # Validations
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :organisation }
  validates :reservation_statuses, presence: true
  validates :slack_before, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :slack_after, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :min_reservation_length, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :max_reservation_length, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  # Model extensions
  audited only: [:name, :description, :slack_before, :slack_after, :min_reservation_length, :max_reservation_length], allow_mass_assignment: true

  # Callbacks
  after_initialize :init, if: :new_record?
  after_create :create_info_screen_entity_types
  after_save :update_reservations_slack_warnings

  # Nested attributes
  accepts_nested_attributes_for :properties, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :reservation_statuses, allow_destroy: true
  accepts_nested_attributes_for :reservation_periods, allow_destroy: true

  # Scopes
  pg_global_search against: { name: 'A', description: 'B' }

  scope :with_entities, -> { where('entities_count > 0') }

  def init
    initialize_reservation_statuses if reservation_statuses.empty?
  end

  def instance_name
    self.name
  end

  def min_reservation_length
    super / 60 if super.present?
  end

  def min_reservation_length=(value)
    super(value.present? ? value.to_i * 60 : nil)
  end

  def min_reservation_length_seconds
    read_attribute(:min_reservation_length)
  end

  def max_reservation_length
    super / 60 if super.present?
  end

  def max_reservation_length_seconds
    read_attribute(:max_reservation_length)
  end

  def max_reservation_length=(value)
    super(value.present? ? value.to_i * 60 : nil)
  end

  def icon_with_default
    if self.icon_without_default.nil?
      EntityTypeIcon.first
    else
      self.icon_without_default
    end
  end
  alias_method_chain :icon, :default

  def default_reservation_status(memory: false)
    if memory
      # Lookup default status in cached statuses ignoring the just destroyed (marked_for_destruction) statuses
      # This is useful for getting the right default status in the middle of create or update actions.
      reservation_statuses.reject(&:marked_for_destruction?).select(&:default_status).first
    else
      # Lookup default status in database
      reservation_statuses.where(default_status: true).first!
    end
  end

  private

  def initialize_reservation_statuses
    reservation_statuses.build(name: I18n.t('reservation_statuses.default.concept'), color: '#fff849', position: 1, default_status: true, blocking: true, info_boards: false, billable: false)
    reservation_statuses.build(name: I18n.t('reservation_statuses.default.definitive'), color: '#ffbc49', position: 2, blocking: true, info_boards: true, billable: true)
    reservation_statuses.build(name: I18n.t('reservation_statuses.default.ready'), color: '#18c13d', position: 3, blocking: true, info_boards: true, billable: true)
    reservation_statuses.build(name: I18n.t('reservation_statuses.default.canceled'), color: '#ff3520', position: 4, blocking: false, info_boards: false, billable: false)
    reservation_statuses.build(name: I18n.t('reservation_statuses.default.not_used'), color: '#939393', position: 5, blocking: true, info_boards: true, billable: true)
  end

  def create_info_screen_entity_types
    if self.organisation.present?
      self.organisation.info_screens.each do |is|
        InfoScreenEntityType.create(entity_type: self, info_screen: is, active: is.add_new_entity_types, add_new_entities: is.add_new_entity_types)
      end
    end
  end

  def update_reservations_slack_warnings
    if self.slack_before_changed? || self.slack_after_changed?
      self.entities.each do |entity|
        entity.update_reservations_slack_warnings(true)
      end
    end
  end
end
