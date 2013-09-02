$(
  $(document).on("change", ".checkbox_group input[type='checkbox']", function(){
    var target = $("#" + $(this).parents('.checkbox_group').data('update'));
    if($(this).is(':checked')){
      var value = target.val();
      if(!!value){
        var exist_value = value.split(',');
        exist_value.push($(this).val());
        target.val(exist_value);
      }else{
        target.val($(this).val());
      }
    }else{

    }
  })
)
