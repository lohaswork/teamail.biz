class UserDiscussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion

  validates :discussion_id, :uniqueness => { :scope => :user_id }
end
