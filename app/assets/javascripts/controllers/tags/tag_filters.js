!function($) {

  App.page.SidebarTags = function (element){
    this.el = element;
    this.init();
  }
  App.page.SidebarTags.prototype = {
    init: function(){
      var self = this;
        $(document).on("click", "#tag-filters li", function(){
          if ($(this).hasClass("active-tag")){
            $(this).find(':checkbox').prop("checked", false);
            $(this).removeClass("active-tag");
          } else {
            $(this).find(':checkbox').prop("checked", "checked");
            $(this).addClass("active-tag");
          }
          $('#tag-filters-submit').trigger("click");
          window.history.pushState({}, "teamail.biz", "/organization_topics");
          $('.headline .breadcrumb').html('<li class="active">团队空间</li>');
          return false;
        });
    }
  }

}(window.jQuery);
