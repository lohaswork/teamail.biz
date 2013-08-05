FactoryGirl.define do
  factory :user_topic do |user_topic|
    user_topic.association :user
    user_topic.association :topic
  end

end

