!function($) {

  App.page.TopicsIndexPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicsIndexPage.prototype = {
    init: function(){
      var page = new App.page.TaggingControls;
      page.refreshTopicList();
    }
  }
}(window.jQuery);
