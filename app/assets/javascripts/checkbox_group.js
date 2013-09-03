$(
  $(document).on("change", ".checkbox_group input[data-item]", function(){
    var target = $("#" + $(this).parents('.checkbox_group').data('update')),
        value = target.val();

    if($(this).is(':checked')){
      if(!!value){
        var exist_value = value.split(',');
        exist_value.push($(this).val());
        target.val(exist_value);
      }else{
        target.val($(this).val());
      }
    }else{
      var exist_value = value.split(',');
      exist_value.splice( $.inArray($(this).val(), exist_value), 1 );
      target.val(exist_value);
    }
  })
)
