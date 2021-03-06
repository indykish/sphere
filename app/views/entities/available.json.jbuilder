json.entities @entities.each do |e|
  json.id e.id
  json.name e.instance_name
  json.color e.color
  json.default_slack_before e.slack_before
  json.default_slack_after e.slack_after
  json.max_slack_before e.max_slack_before(@begins_at)
  json.max_slack_after e.max_slack_after(@ends_at)
end

if @selected_entity.present?
  json.selected_entity do
    json.available @selected_entity.is_available_between?(@begins_at, @ends_at, ignore_reservations: params[:reservation_id])
    json.begins_at_error @selected_entity_reservation.errors[:begins_at].present?
    json.ends_at_error @selected_entity_reservation.errors[:ends_at].present?
    json.default_slack_before @selected_entity.slack_before
    json.default_slack_after @selected_entity.slack_after
    json.max_slack_before @selected_entity.max_slack_before(@begins_at)
    json.max_slack_after @selected_entity.max_slack_after(@ends_at)
  end
end
