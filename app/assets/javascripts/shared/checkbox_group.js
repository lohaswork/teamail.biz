!function($) {

  App.page.CheckBoxGroup = function (element){
    this.el = element;
    this.init();
  }
  App.page.CheckBoxGroup.prototype = {
    init: function(){
      $(document).on("change", ".checkbox-group input", function(){
        var me = $(this);
        if (me.is(':checked')) {
          me.trigger('checked');
        }else{
          me.trigger('unchecked');
        }
      })
      .on('checked', ".checkbox-group input[data-item]", function(){
        var me = $(this),
            target = $(me.parents('.checkbox-group').data('update')),
            value =target.val();

        value = value.split(',');
        value.push(me.val());
        //remove the empity value for first element
        target.val(value.filter(function(e){return e}));
      })
      .on('unchecked', ".checkbox-group input[data-item]", function(){
        //some duplicate code here, should refector it as ObjeceOriented code
        var me = $(this),
            target = $(me.parents('.checkbox-group').data('update')),
            value =target.val();

        value = value.split(',');
        value.splice( $.inArray(me.val(), value), 1 );
        target.val(value);
      })
      .on('change', '.checkbox-group input[data-all]', function(){
        var selectAll = $(this);
        $(".checkbox-group input[data-item]").prop('checked', function(){
          var me = $(this),
              checkStatus = selectAll.is(':checked'),
              checkEvent = checkStatus ? 'checked' : 'unchecked';
          //if the checkbox status is not same as the select-all, then change and trigger the event
          if (me.is(':checked') !== checkStatus) {
            me.trigger(checkEvent);
          }
          return checkStatus;
        });
      })

      $(".checkbox-group input[data-item]").prop('checked', function(){
        var me = $(this),
            checkStatus = me.data('selected');
        if (checkStatus){
          me.trigger('checked');
        }
        return checkStatus;
      })
    }
  }

}(window.jQuery);
