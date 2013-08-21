FactoryGirl.define do
  factory :discussion do
    content
  end

  sequence :content do |n|
    "hello, everyone, this is the discussion content#{n}, welcome to join us!"
  end
end
