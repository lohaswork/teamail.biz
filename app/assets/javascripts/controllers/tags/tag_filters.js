!function($) {

  App.page.SidebarTags = function (element){
    this.el = element;
    this.init();
  }
  App.page.SidebarTags.prototype = {
    init: function(){
      var self = this;
        $(document).on("click", "#tag-filters li", function(e){
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
        });
    }
  }

}(window.jQuery);
