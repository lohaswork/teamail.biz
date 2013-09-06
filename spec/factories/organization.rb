FactoryGirl.define do
  factory :organization do
    name "test organization"

    factory :organization_with_topic do
      after(:create) do |organization|
        organization.topics << create(:topic, title:"organization_with_topic")
      end
    end
  end
end

