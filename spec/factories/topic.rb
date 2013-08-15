FactoryGirl.define do
  factory :topic do
    title
    after(:create) do |topic|
      topic.users << topic.organization.users
      10.times do
        create(:discussion, topic: topic)
      end
    end
  end

  sequence :title do |n|
    "this is test topic#{n}"
  end
end
