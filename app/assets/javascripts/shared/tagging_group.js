!function($) {

  App.page.TaggingGroup = function (element){
    this.el = element;
    this.init();
  }
  App.page.TaggingGroup.prototype = {
    init: function(){

      $("#tagging-dropdown").click(function(){
        $('.dropdown-menu').toggle();
      });

    }
  }

}(window.jQuery);
