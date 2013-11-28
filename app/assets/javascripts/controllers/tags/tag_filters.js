!function($) {

  App.page.SidebarTags = function (element){
    this.el = element;
    this.init();
  }
  App.page.SidebarTags.prototype = {
    init: function(){
      var self = this,
          activeTag = [];
        $("#tag-filters").on("click", "li", filterTopic);
        $("#tag-filters").on("click", ".manage-tag", function(e){
          var $btn = $(this);
          $btn.toggleClass("btn-selected");

          if ($btn.hasClass("btn-selected")) {
            $("#tag-filters li").each(function(){
              if ($(this).hasClass("active-tag")) {
                activeTag.push($(this));
                $(this).removeClass("active-tag")
                $(this).find(".fa-times").hide();
              }
            });
            $(".hide-tag-link").show();
            $("#tag-filters").off("click", "li", filterTopic);
          } else {
            $(".hide-tag-link").hide();
            $.each(activeTag, function(){
              this.addClass("active-tag");
              this.find(".fa-times").show();
            });
            activeTag = [];
            $("#tag-filters").on("click", "li", filterTopic);
          }
          e.stopPropagation;
        })
        .on("click", ".hide-tag-link",function(e){
          var self = this;
          $("#tag-filters").on('ajax:success', ".hide-tag-link", function(){
            $(self).parent("li").remove();
          });
          e.stopPropagation;
        });

        function filterTopic(e) {
          var $tag = $(this);
          if ($tag.hasClass("active-tag")){
            $tag.find(':checkbox').prop("checked", false);
            $tag.removeClass("active-tag");
            $tag.find(".fa-times").hide();
          } else {
            $tag.find(':checkbox').prop("checked", "checked");
            $tag.addClass("active-tag");
            $tag.find(".fa-times").show();
          }
          $('#tag-filters-submit').trigger("click");
          window.history.pushState({}, "teamail.biz", "/organization_topics");
          // $('.headline .breadcrumb').html('<li class="active">团队空间</li>');
          e.stopPropagation();
        };
    }
  }

}(window.jQuery);
