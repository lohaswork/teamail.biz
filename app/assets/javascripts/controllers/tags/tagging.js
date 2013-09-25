!function($) {

  App.page.TaggingSelectPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TaggingSelectPage.prototype = {

    init: function(){
      $(document).on("click", "#select-topic input[data-item]", function(){
        var check_status = 0;
        var checkbox_group = $("#select-topic").find(':checkbox')
        checkbox_group.each(function(index,element) {
          if($(element).prop('checked')){
            check_status += 1;
          }
        });
        if (check_status > 0) {
          $("#tagging-dropdown").attr("disabled",false);
        } else {
          $("#tagging-dropdown").attr("disabled","disabled");
        }
      });
    }
  }

}(window.jQuery);
