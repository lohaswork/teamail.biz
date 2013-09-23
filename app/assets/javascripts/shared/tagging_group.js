!function($) {

  App.page.TaggingGroup = function (element){
    this.el = element;
    this.init();
  }
  App.page.TaggingGroup.prototype = {

    init: function(){
      var self = this;
      $(document).on("click", "#tag-list input[data-item]", function(){
        var check_status = 0;
        var checkbox_group = $("#tag-list").find(':checkbox')
        checkbox_group.each(function(index,element) {
          if($(element).prop('checked')){
            check_status += 1;
          }
        });
        if (check_status > 0) {
          $("#tagging-submit").show();
          $("#tag-input").hide();
        } else {
          $("#tagging-submit").hide();
          $("#tag-input").show();
        }
      });

      self.el.on('click', '#tagging-dropdown', function(){
        $('#dropdown-tags').toggle();
        return false;
      });
      self.el.on('keyup', '#tag_name', function(){
        if ($('#tag_name').val() != "") {
          $("#tag-submit").attr("disabled",false);
        } else {
          $("#tag-submit").attr("disabled","disabled");
        }
      });
    }
  }

}(window.jQuery);
