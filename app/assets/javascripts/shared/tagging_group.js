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
      });
      self.el.on('keyup', '#tag_name', function(){
        if ($('#tag_name').val() != "") {
          $("#tag_submit").attr("disabled",false);
        } else {
          $("#tag_submit").attr("disabled","disabled");
        }
      });
    }
  }

}(window.jQuery);
