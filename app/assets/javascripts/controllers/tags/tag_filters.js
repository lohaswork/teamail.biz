!function($) {

  App.page.SidebarTags = function (element){
    this.el = element;
    this.init();
  }
  App.page.SidebarTags.prototype = {
    init: function(){
      var self = this;
        $('#tag-filters a').click(function(){
          if ($(this).hasClass("active-tag")){
            return false;
          } else {
            $('#tag-filters a').removeClass("active-tag");
            $(this).addClass("active-tag");
          }
        });
    }
  }

}(window.jQuery);
