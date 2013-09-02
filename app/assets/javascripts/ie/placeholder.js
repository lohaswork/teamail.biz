//Assign to those input elements that have 'placeholder' attribute
$('input[placeholder]').each(function(){
    var input = $(this);
    $(input).val(input.attr('placeholder'));

    $(input).focus(function(){
        if (input.val() == input.attr('placeholder')) {
           input.val('');
        }
    });

    $(input).blur(function(){
       if (input.val() == '' || input.val() == input.attr('placeholder')) {
           input.val(input.attr('placeholder'));
       }
    });
});
