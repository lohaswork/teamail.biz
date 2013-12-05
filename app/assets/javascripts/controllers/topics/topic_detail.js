!function($) {

  App.page.TopicDetails = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicDetails.prototype = {
    init: function(){
      new App.page.TopicCheckControls;
      $(document).ready(function() {
        $("#tagging-dropdown").attr("disabled",false);
        $(".content a").attr('target', '_blank');
        $(".content").each(function() {
          var $blockquote = $(this).find("blockquote");
          $blockquote.each(function() {
            var self = this;
            if ($(self).parentsUntil( $(".content"), "blockquote" ).length === 0) {
              $(self).hide();
              var $toggleBtn = $("<br><button class='toggle-quote'></button><br>");
              $toggleBtn.insertBefore($(self));
              $toggleBtn.on("click", function(){
                $(self).toggle();
              });
            }
          })
        });
      });
      $(document).on("refreshed", ".headline-tag-container", function(e) {
        $("#dropdown-tags").hide();
        $("#tag-list :checkbox").attr('checked', false);
        $("#tagging-submit").hide();
        $("#tag-input").show();
        e.stopPropagation();
      })
      .on("refreshed", "#select-user-for-topic", function(e){
        e.stopPropagation();
      })
      .on("refreshed", "#select-user-for-discussion", function(e){
        e.stopPropagation();
      })
      .on("refreshed", "#new-discussion", function(e){
        e.stopPropagation();
      })
      .on("refreshed", "#discussion-list", function(e){
        var editor = $('<div class="qeditor_preview clearfix" contentEditable="true"></div>');
        var placeholder = $('<div class="qeditor_placeholder">请输入内容</div>');
        $(".qeditor_preview").html(placeholder);
        e.stopPropagation();
      })
      .on("refreshed", "#topic-area", function(e) {
        $('.timeago').timeago();
        window.history.pushState({}, "teamail.biz", "/organization_topics");
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
        e.stopPropagation();
      });
    }
  }
}(window.jQuery);
