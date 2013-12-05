jQuery ->
  # Initialize the jQuery File Upload widget:
  $('#fileupload').fileupload
    dataType: 'json'
    autoUpload: true
    progress: (e,data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')

    done: (e, data) ->
      that = this
      hiddenElement = $('#upload_success_files')
      value = hiddenElement.val()
      fileId = data.result.files[0].id

      # Push file id to hidden field
      if value then value = value.split(',') else value = []
      value.push(fileId) if $.inArray(fileId, value) == -1
      hiddenElement.val(value)

      # Call original method
      $.blueimp.fileupload.prototype.options.done.call(that, e, data);
