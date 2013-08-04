FactoryGirl.define do
  factory :organizaiton_memberships do |organizaiton_membership|
    organizaiton_membership.association :user
    organizaiton_membership.association :organization
  end

end
