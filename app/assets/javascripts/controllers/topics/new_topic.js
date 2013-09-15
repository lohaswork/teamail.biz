!function($) {

  App.page.NewTopicPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.NewTopicPage.prototype = {
    init: function(){
      var self = this;
      self.el.on('click', '#new-topic-button', function(){
        $('#new-topic-form').show();
        return false;
      })
      .on('click', '#cancel-create-button', function(){
        $('#new-topic-form').hide();
        return false;
      })
    }
  }

}(window.jQuery);
