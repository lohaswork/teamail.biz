class UserDiscussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion
end
