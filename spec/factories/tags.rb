# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    name
    color
  end
  sequence :name do |n|
    "tag#{n}tag"
  end
  sequence :color do |n|
    "color#{n}color"
  end
end
