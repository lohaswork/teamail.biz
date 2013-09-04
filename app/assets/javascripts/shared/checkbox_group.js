$(
  $(document).on("change", ".checkbox_group input", function(){
    var me = $(this);
    if (me.is(':checked')) {
      me.trigger('checked');
    }else{
      me.trigger('unchecked');
    }
  })
  .on('checked', ".checkbox_group input[data-item]", function(){
    var me = $(this),
        target = $(me.parents('.checkbox_group').data('update')),
        value =target.val();

    value = value.split(',');
    value.push(me.val());
    //remove the empity value for first element
    target.val(value.filter(function(e){return e}));
  })
  .on('unchecked', ".checkbox_group input[data-item]", function(){
    //some duplicate code here, should refector it as ObjeceOriented code
    var me = $(this),
        target = $(me.parents('.checkbox_group').data('update')),
        value =target.val();

    value = value.split(',');
    value.splice( $.inArray(me.val(), value), 1 );
    target.val(value);
  })
)
