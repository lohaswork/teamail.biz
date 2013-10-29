FactoryGirl.define do
  factory :topic do
    title
  end

  sequence :title do |n|
    "this is test topic#{n}, for test"
  end
end
