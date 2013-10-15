!function($) {

  App.page.UsersTopicsPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.UsersTopicsPage.prototype = {
    init: function(){
      var page = new App.page.TopicCheckControls;
      page.refreshTopicList();
    }
  }

}(window.jQuery);
