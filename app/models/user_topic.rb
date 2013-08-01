class UserTopic < ActiveRecord::Base
  attr_accessible :user_id, :topic_id, :archive_status
  belongs_to :user
  belongs_to :topic
end
