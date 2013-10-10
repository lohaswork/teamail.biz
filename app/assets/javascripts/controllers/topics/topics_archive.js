!function($) {

  App.page.TopicsUnarchivedPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicsUnarchivedPage.prototype = {
    init: function(){
      $(document).on("click", "#select-topic input[data-item]", function(){
        if (sumCheckStatus("#select-topic") > 0) {
          $("#archive-submit").attr("disabled",false);
        } else {
          $("#archive-submit").attr("disabled","disabled");
        }
      });

      var sumCheckStatus = function(check_element) {
        var check_status = 0;
        var checkbox_group = $(check_element).find(':checkbox');
        checkbox_group.each(function(index,element) {
          if($(element).prop('checked')){
            check_status += 1;
          }
        });
        return check_status;
      };
    }
  }
}(window.jQuery);
