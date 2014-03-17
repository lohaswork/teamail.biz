json.set! :total_count, @total_count
json.set! :topics do
  json.array! @topics do |topic|
    json.id topic.id
    json.title topic.title
    json.creator topic.creator.email
    json.update_at topic.updated_at
    json.has_attachments topic.has_attachments?
    json.read_status topic.read_status_of_user(@current_user)
    json.set! :tags do
      json.array! topic.tags do |tag|
        json.id   tag.id
        json.name tag.name
        json.color tag.color
      end
    end
  end
end
