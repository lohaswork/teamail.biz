!function($) {

  App.page.TaggingGroup = function (element){
    this.el = element;
    this.init();
  }
  App.page.TaggingGroup.prototype = {
    init: function(){
      var self = this;
      self.el.on('click', '#tagging-dropdown', function(){
        $('#dropdown-tags').toggle();
        return false;
      })
    }
  }

}(window.jQuery);
