FactoryGirl.define do
  factory :organization do
    name "test organization"
    after(:create) do |organization|
      10.times do
        create(:topic, organization:organization)
      end
    end
  end

  factory :topic do
    title
  end

  sequence :title do |n|
    "this is test topic#{n}"
  end
end

