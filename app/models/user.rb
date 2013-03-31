class User < ActiveRecord::Base
  attr_accessible :active_status, :authority, :email, :name, :online_status, :organization_id, :password, :remember_token
end
