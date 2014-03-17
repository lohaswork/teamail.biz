json.set! :total_count, @total_count
json.set! :topics do
  json.array! @topics do |topic|
    json.id topic.id
    json.title topic.title
    json.update_at topic.updated_at
  end
end

