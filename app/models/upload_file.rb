class UploadFile < ActiveRecord::Base
  attr_accessible :file, :name
  mount_uploader :file, AttachmentUploader

  belongs_to :discussion
end
