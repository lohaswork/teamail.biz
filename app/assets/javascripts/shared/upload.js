!function($) {

  App.page.UploadPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.UploadPage.prototype = {
    init: function(){

          // Initialize the jQuery File Upload widget:
          $('#fileupload').fileupload({
            dataType: 'json',
            autoUpload: false,
            acceptFileTypes:  /(\.|\/)(gif|jpe?g|png)$/i,
            maxNumberOfFiles : 3,
            maxFileSize: 5000000
          });
          //
          // Load existing files:
          $.getJSON($('#fileupload').prop('action'), function (files) {
            var fu = $('#fileupload').data('blueimpFileupload'),
              template;
            fu._adjustMaxNumberOfFiles(-files.length);
            console.log(files);
            template = fu._renderDownload(files)
              .appendTo($('#fileupload .files'));
            // Force reflow:
            fu._reflow = fu._transition && template.length &&
              template[0].offsetWidth;
            template.addClass('in');
            $('#loading').remove();
          });


    }
  }
}(window.jQuery);
