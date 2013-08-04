FactoryGirl.define do
  factory :topic do
    title
    after(:create) do |topic|
      topic.users << topic.organization.users
    end
  end

  sequence :title do |n|
    "this is test topic#{n}"
  end
end
