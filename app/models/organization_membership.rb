class OrganizationMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  scope :current_pair, lambda { |user, organ| where("user_id = ? AND organization_id = ?", user.id, organ.id) }
end
