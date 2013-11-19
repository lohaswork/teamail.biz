!function($) {

  App.page.TopicsShowPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicsShowPage.prototype = {
    init: function(){
      new App.page.TopicCheckControls;
      $(document).ready(function() {
        $("#tagging-dropdown").attr("disabled",false);
        $(".content a").attr('target', '_blank');
        $(".content blockquote").hide();
        $.each($(".content"), function() {
          $("<button class='toggle-quote'></button><br>").insertBefore($(this).find("blockquote").first());
        });
      });
      $(document).on("refreshed", ".headline-tag-container", function () {
        $("#dropdown-tags").hide();
        $("#tag-list :checkbox").attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
        return false;
      })
      .on("click", ".toggle-quote", function(){
        $(this).parents('.content').find('blockquote').toggle();
      })
      .on("refreshed", "#discussion-list", function(){
        return false;
      })
      .on("refreshed", "#select-user-for-topic", function(){
        return false;
      })
      .on("refreshed", "#discussion-list", function(){
        $(".content a").attr('target', '_blank');
        var editor = $('<div class="qeditor_preview clearfix" contentEditable="true"></div>');
        var placeholder = $('<div class="qeditor_placeholder">请输入内容</div>');
        $(".qeditor_preview").html(placeholder);
        $(".content blockquote").hide();
        $.each($(".content"), function() {
          $("<button class='toggle-quote'></button>").insertBefore($(this).find("blockquote").first());
        });
        return false;
      })
      .on("refreshed", "#select-user-for-discussion", function(){
        $("#new-discussion #invited_emails").val("");
        return false;
      })
      .on("refreshed", "#topic-area", function () {
        $('.timeago').timeago();
        window.history.pushState({}, "teamail.biz", "/organization_topics");
        $('.headline h4').html('话题列表');
        $('.topic-check-all').show();
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
