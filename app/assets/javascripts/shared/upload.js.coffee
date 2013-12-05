jQuery ->
  # Initialize the jQuery File Upload widget:
  $('#fileupload').fileupload
    dataType: 'json'
    autoUpload: true
    filesContainer: $('table.files')
    downloadTemplateId: null
    uploadTemplateId: null
    progress: (e,data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')

    done: (e, data) ->
      that = this;
      $.blueimp.fileupload.prototype.options.done.call(that, e, data);
