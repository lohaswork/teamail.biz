$(document).ready(function(){
  //Delegate the event on document is not good, maybe need have a JS patten later
  $(document).on('click', '#new-topic-button', function(){
    $('#new-topic-form').show();
    return false;
  }).on('click', '#cancel-create-button', function(){
    $('#new-topic-form').hide();
    return false;
  })
});
