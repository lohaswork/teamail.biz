!function($) {

  App.page.TopicsShowPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicsShowPage.prototype = {
    init: function(){
      new App.page.TopicCheckControls;
      $(document).ready(function(){
        $("#tagging-dropdown").attr("disabled",false);
      });
      $(document).on("refreshed", ".headline-tag-container", function () {
        $("#dropdown-tags").hide();
        $("#tag-list :checkbox").attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
      });
    }
  }
}(window.jQuery);
