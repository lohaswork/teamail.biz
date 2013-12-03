class UploadFile < ActiveRecord::Base
  attr_accessible :file, :name
  mount_uploader :file, AttachmentUploader

  belongs_to :discussion

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:name),
      "id" => read_attribute(:id),
      #"size" => read_attribute(:size),
      #"url" => self.file.url(:original),
      "delete_url" => upload_file_path(self),
      "delete_type" => "DELETE"
    }
  end
end
