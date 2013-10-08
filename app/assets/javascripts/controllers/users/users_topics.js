!function($) {

  App.page.UsersTopicsPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.UsersTopicsPage.prototype = {
    init: function(){
      new App.page.TaggingControls
      $(document).on("refreshed", "#topic-list", function () {
        $("#dropdown-tags").hide();
        $("#tagging-dropdown").attr("disabled","disabled");
        $("#tag-list :checkbox").attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
      });
    }
  }

}(window.jQuery);
