class ActiveCode < ActiveRecord::Base
  attr_accessible :code, :user_id
  belongs_to :user
  
end

