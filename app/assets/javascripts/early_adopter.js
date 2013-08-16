function showErrors(data){
  $('.error').html(data.errors).show();
}
$(document)
  .on( 'ajax:before', 'form',function (e) {

  })
  .on('ajax:success', 'form', function (e, data, status, xhr) {
    $('.create').html(data);
  })
  .on( 'ajax:error', 'form[data-remote], a[data-remote]',function (e, xhr, status, error) {
    var data = null;
    try { data = $.parseJSON(xhr.responseText); }
    catch (e) {}
    if(data.update) {
    }
    if (xhr.status > 399 && xhr.status < 500) {
      if (data) {
        showErrors(data);
      }
    }
  });
