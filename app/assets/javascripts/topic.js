$(document).ready(function(){
  $('#new-topic-button').on('click', function(){
    $('#new-topic-form').show();
    return false;
  })

  $('#cancel-create-button').on('click', function(){
    $('#new-topic-form').hide();
    return false;
  })
});
