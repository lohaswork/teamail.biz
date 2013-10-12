!function($) {

  App.page.TopicsUnarchivedPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.TopicsUnarchivedPage.prototype = {
    init: function(){
      var page = new App.page.TaggingControls;
      page.refreshTopicList();
    }
  }
}(window.jQuery);
