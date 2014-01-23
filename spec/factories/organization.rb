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
          topic = create(:topic)
          create_first_discussion(user, topic)
          user.topics << topic
          user.default_organization = organization
          user.save
          organization.topics << topic
          organization.users << user
          organization.membership(user).update_attribute(:formal_type, 1)
          organization.tags << tag
        end
      end
    end
  end
end

def create_first_discussion(user, topic)
      discussion = create(:discussion, user_from: user.id, discussable: topic)
end
