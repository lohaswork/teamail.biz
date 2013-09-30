!function($) {

  App.page.TopicsIndexPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicsIndexPage.prototype = {
    init: function(){
      new App.page.TaggingControls
    }
  }

}(window.jQuery);
