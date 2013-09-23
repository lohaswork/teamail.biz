# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging do
    taggable_type "Topic"
    taggable_id 1
    tag_id 1
  end
end
