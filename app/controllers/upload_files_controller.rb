class UploadFilesController < ApplicationController

  def create
    uploadfile = UploadFile.create params[:upload]

    render :json => {
      :files => [uploadfile.to_jq_upload]
      },
    :status => :created

  end

  # Not used for now, but need refactor later
  # def download
  #   file = UploadFile.find(params[:id])
  #   data = open(file.file.url)
  #   send_data data.read, filename: file.name, type: file.content_type, disposition: 'attachment', stream: 'true', buffer_size: '4096'
  # end

  def destroy
    upload = UploadFile.find(params[:id])
    upload.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
