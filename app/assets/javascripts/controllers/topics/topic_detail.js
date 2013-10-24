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
        return false;
      })
      .on("refreshed", "#discussion-list", function(){
        return false;
      })
      .on("refreshed", "#select-user-for-topic", function(){
        return false;
      })
      .on("refreshed", "#select-user-for-discussion", function(){
        $("#new-discussion #invited_emails").val("");
        $("#new-discussion #content").val("");
        return false;
      })
      .on("refreshed", "#topic-area", function () {
        window.history.pushState({}, "teamail.biz", "/organization_topics");
        $("#tagging-dropdown").attr("disabled","disabled");
        $("#archive-form").remove();
        $(document).on("click", "#select-topic input[data-item]", function(){
          if (sumCheckStatus("#select-topic") > 0) {
            $("#archive-submit").attr("disabled",false);
            $("#tagging-dropdown").attr("disabled",false);
          } else {
            $("#archive-submit").attr("disabled","disabled");
            $("#tagging-dropdown").attr("disabled","disabled");
          }
        })
        return false;
      });
    }
  }
}(window.jQuery);
