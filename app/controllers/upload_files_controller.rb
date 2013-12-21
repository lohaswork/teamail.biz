class UploadFilesController < ApplicationController

  def create
    uploadfile = UploadFile.create params[:upload]

    render :json => {
      :files => [uploadfile.to_jq_upload]
      },
    :status => :created

  end

  def download
    file = UploadFile.find(params[:id])
    url = file.file.url
    redirect_to url
  end

  def destroy
    upload = UploadFile.find(params[:id])
    upload.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
