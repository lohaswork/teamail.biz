class OrganizationMembership < ActiveRecord::Base
  attr_accessible :authority_type, :organization_id, :user_id
  belongs_to :user
  belongs_to :organization
end
