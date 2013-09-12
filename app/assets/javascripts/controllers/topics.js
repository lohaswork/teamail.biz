App.page.TopicsIndexPage = function (element){
  this.init = function (){
    this.el = element;
  };

  (function(me){
    me.init();
    me.el.on('click', '#new-topic-button', function(){
      $('#new-topic-form').show();
      return false;
    })
    .on('click', '#cancel-create-button', function(){
      $('#new-topic-form').hide();
      return false;
    })
  }(this))
}
