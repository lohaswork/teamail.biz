json.id topic.id
json.title topic.title
json.creator topic.creator.email
json.update_at topic.updated_at
json.has_attachments topic.has_attachments?
json.read_status topic.read_status_of_user(@current_user)
json.tags topic.tags do |tag|
  json.id   tag.id
  json.color tag.color
end
