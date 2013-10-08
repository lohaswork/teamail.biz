!function($) {

  App.page.UsersTopicsPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.UsersTopicsPage.prototype = {
    init: function(){
      new App.page.TaggingControls
      $(document).on("click", "#select-topic input[data-item]", function(){
        if (sumCheckStatus("#select-topic") > 0) {
          $("#tagging-dropdown").attr("disabled",false);
        } else {
          $("#tagging-dropdown").attr("disabled","disabled");
        }
      })
      .on("refreshed", "#topic-list", function () {
        $("#dropdown-tags").hide();
        $("#tagging-dropdown").attr("disabled","disabled");
        $("#tag-list :checkbox").attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
      });
    }
  }

}(window.jQuery);
