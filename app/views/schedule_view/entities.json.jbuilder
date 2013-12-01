json.entity_types @entity_types.each do |et|
  json.id et.id
  json.name et.instance_name
  json.entities et.entities.each do |e|
    json.id e.id
    json.name e.instance_name
    json.color e.color
    json.icon et.icon.image.icon.url
  end
end