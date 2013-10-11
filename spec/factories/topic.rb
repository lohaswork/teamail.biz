FactoryGirl.define do
  factory :topic do
    title
    after(:create) do |topic|
      discussion = create(:discussion, discussable: topic)
    end
  end

  sequence :title do |n|
    "this is test topic#{n}"
  end
end
