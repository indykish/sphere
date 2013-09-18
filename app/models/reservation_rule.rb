class ReservationRule < ActiveRecord::Base
  include DatetimeSplittable
  include I18n::Alchemy

  belongs_to :entity
  belongs_to :period_unit, class_name: 'TimeUnit'

  validates :entity, presence: true
  validates :period_unit_id, presence: true
  validates :period_unit, presence: true, if: "period_unit_id.present?"
  validates :period_amount, presence: true
  validates :active_from, presence: true
  validates :active_to, presence: true
  validates :min_periods, presence: true, numericality: { only_integer: true }
  validates :max_periods, numericality: { only_integer: true }, allow_nil: true
  validates :price, presence: true, numericality: true

  split_datetime :active_from, :active_to

  def instance_name
    self.id
  end
end