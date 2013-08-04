FactoryGirl.define do
  factory :organization do
    name "test organization"
    after(:create) do |organization|
      organization.users << create(:already_activate_user)
      10.times do
        create(:topic, organization:organization)
      end
    end
  end
end

