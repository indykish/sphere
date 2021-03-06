class DataType < ActiveRecord::Base
  # Validations
  validates :key, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :rails_type, presence: true, length: { maximum: 255 }
  validates :form_type, presence: true, length: { maximum: 255 }

  def instance_name
    self.key
  end

  def human_name
    I18n.t("data_types.#{key}.name")
  end

  def human_description
    I18n.t("data_types.#{key}.description")
  end

  def string?
    self.key == 'string'
  end

  def integer?
    self.key == 'integer'
  end

  def float?
    self.key == 'float'
  end

  def has_required?
    self.key != 'boolean'
  end

  def cast_value(value)
    return nil if value.blank?

    case self.rails_type
    when 'Integer'
      Integer(value)
    when 'Float'
      Float(value)
    when 'Boolean'
      ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
    else
      value
    end
  end

  def parse_value(value)
    cast_value(parsed) rescue value
  end

  def format_value(value)
    return value if value.nil? # We cannot check on blank, because else the boolean false is not formatted correctly.

    case self.rails_type
    when 'Boolean'
      I18n.t(value.to_s)
    else
      value
    end
  end
end
