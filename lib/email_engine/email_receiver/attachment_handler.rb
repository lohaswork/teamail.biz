# encoding: utf-8
module EmailEngine
  module Emailreceiver

    module AttachmentHandler
      def post_attachments_to_oss(discussion)
        methods.grep(/^attachment_\d+$/) do |file_key|
          file = self.send file_key
          uploadfile = UploadFile.new
          uploadfile.file = file
          uploadfile.name = file.original_filename
          discussion.upload_files << uploadfile
        end
        discussion.save!
      end

      def has_attachments?
        attachments_number != 0
      end

      private
      def attachments_number
        attachment_count.to_i
      end

    end

  end
end