!function($) {

  App.page.UsersTopicsPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.UsersTopicsPage.prototype = {
    init: function(){
      new App.page.TaggingControls
    }
  }

}(window.jQuery);
