!function($) {

  App.page.NewTopicPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.NewTopicPage.prototype = {
    init: function(){
      var self = this;
      self.el.on('click', '#create-new-topic', function(){
        $('#myModal').modal();
        $('#myModal').on('shown.bs.modal', function () {
          $('#myModal .modal-body #title').focus();
        });
      });
      $(document).on('hidden.bs.modal', '#myModal', function (){
        $('#myModal :text').val("");
      })
      .on("click", "#select-user-for-topic .all", function(){
        var btnAll = $(this);
        btnAll.toggleClass("selected");
        var checkStatus = btnAll.hasClass("selected") ? true : false;
        btnAll.parents(".user-select").find(":checkbox").prop('checked', checkStatus);
      });
    }
  }

}(window.jQuery);
