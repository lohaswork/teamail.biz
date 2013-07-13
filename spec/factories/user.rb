FactoryGirl.define do
  sequence :email do |n|
      "person#{n}@test.com"
  end
  
  sequence :active_code do |n|
      SecureRandom.urlsafe_base64
  end
  
  factory :user do
    email 
    password '123456'
    active_code
    
    factory :non_activate_user do
    end
    
    factory :already_activate_user do
      active_status 1
    end
  end

end