json.array! @topics do |topic|
  json.id topic.id
  json.title topic.title
  json.update_at topic.updated_at
end
