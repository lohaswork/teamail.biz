json.set! :total_count, @total_count
json.topics @topics do |topic|
  json.partial! 'topics/topic', topic: topic
end
