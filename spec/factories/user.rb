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

    factory :non_activate_user do
    end

    factory :already_activate_user do
      active_status 1
    end

    factory :should_reset_user do
      reset_token
    end
  end

end
