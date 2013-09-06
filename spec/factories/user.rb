FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@test.com"
  end

  sequence :active_code do
    SecureRandom.urlsafe_base64
  end

  sequence :reset_token do
    SecureRandom.urlsafe_base64
  end

  factory :user do
    email
    password 'password'
    active_code

    factory :normal_user do
      after(:create) do |user|
        organization = create(:organization)
        10.times do
          topic = create(:topic)
          organization.topics << topic
          create_discussion(user, topic)
          user.topics << topic
        end
        user.organizations << organization
      end
      active_status 1
    end

    factory :non_activate_user do
    end

    factory :should_reset_user do
      reset_token
    end
  end

end

def create_discussion(user, topic)
    10.times do
      discussion = create(:discussion, user_from: user.id, topic:topic)
      discussion.users << user
    end
end
