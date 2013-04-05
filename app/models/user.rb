class User < ActiveRecord::Base
  attr_accessible :active_status, :authority, :email, :name, :online_status, :organization_id, :password, :remember_token
  belongs_to :organization

  def self.create_with_organization(email, pwd, organization_name)
    user = User.new(:email => email, :password => pwd)
    organ = Organization.create(:name => organization_name)
    user.organization_id = organ.id
    user.save
    user
  end

end
