class FilesController < ApplicationController

  def create
    uploadfile = UploadFile.new
    file = params[:discussion_file]
    uploadfile.file = file
    uploadfile.save!
    render :nothing => true
  end

  def download
    file = UploadFile.find(params[:id])
    data = open(file.file.url)
    send_data data.read, filename: file.name, type: file.content_type, disposition: 'attachment', stream: 'true', buffer_size: '4096'
  end

  def delete
    file = UploadFile.find(params[:id])
    file.remove_file!
    file.destroy!
    discussion = file.discussion

    render :json => {
                :update => {
                            "attachments-in-discussion" => render_to_string(:partial => 'topics/discussion_attachments',
                                                                            :layout => false,
                                                                            :locals => {
                                                                                :discussion => discussion
                                                                           })
                          }
                      }

  end
end
