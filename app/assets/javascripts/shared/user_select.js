!function($) {

  App.page.UserSelect = function (){
    this.init();
  }
  App.page.UserSelect.prototype = {
    init: function(){
      $("#select-user-for-discussion").on("click", ".all", function(){
        var btnAll = $(this);
        btnAll.toggleClass("selected");
        var checkStatus = btnAll.hasClass("selected") ? true : false;
        btnAll.parents(".user-select").find(":checkbox").prop('checked', checkStatus);
      });
      $(".user-select :checkbox").prop('checked', function(){
        var me = $(this),
            checkStatus = me.data('selected');
        return checkStatus;
      });
    }
  }

}(window.jQuery);
