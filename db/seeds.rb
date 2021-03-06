# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
I18n.locale = :nl

# Create default data types
DataType.create!([
  { key: 'string', rails_type: 'String', form_type: 'text_field' },
  { key: 'text', rails_type: 'String', form_type: 'text_area' },
  { key: 'integer', rails_type: 'Integer', form_type: 'text_field' },
  { key: 'float', rails_type: 'Float', form_type: 'text_field' },
  { key: 'boolean', rails_type: 'Boolean', form_type: 'check_box' },
  { key: 'enum', rails_type: 'String', form_type: 'collection_select' },
  { key: 'set', rails_type: 'Array', form_type: 'collection_select_multi' },
])

# Create default time periods
TimeUnit.create!([
  { key: 'second', repetition_key: 'secondly', seconds: 1.second },
  { key: 'minute', repetition_key: 'minutely', seconds: 1.minute },
  { key: 'quarter', repetition_key: 'quarterly', seconds: 15.minutes },
  { key: 'half_hour', repetition_key: 'half_hourly', seconds: 30.minutes },
  { key: 'hour', repetition_key: 'hourly', seconds: 1.hour },
  { key: 'day', repetition_key: 'daily', seconds: 1.day },
  { key: 'week', repetition_key: 'weekly', seconds: 1.week },
  { key: 'month', repetition_key: 'monthly', seconds: 1.month },
  { key: 'year', repetition_key: 'yearly', seconds: 1.year.to_i },
  { key: 'infinite', repetition_key: nil, seconds: nil }
])

# Create default roles
OrganisationRole.create!(name: 'Administrator')
OrganisationRole.create!(name: 'Planner')
OrganisationRole.create!(name: 'Viewer')

# Create the default entity type icon
EntityTypeIcon.create!(name: 'Object')
