FactoryGirl.define do
  factory :organization do
    name "test organization"

    factory :organization_with_topic do
      after(:create) do |organization|
        organization.topics << create(:topic, title:"organization_with_topic")
      end
    end

    factory :organization_with_multi_users do
      after(:create) do |organization|
        10.times do
          user = create(:clean_user)
          tag = create(:tag)
          user.default_organization = organization
          user.save
          organization.users << user
          organization.tags << tag
        end
      end
    end
  end
end

